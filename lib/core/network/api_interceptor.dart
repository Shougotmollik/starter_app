import 'package:api_learning/core/network/api_endpoint.dart';
import 'package:api_learning/core/network/token_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  static const int _maxRetries = 2;

  AuthInterceptor({required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final needAuth = options.extra['needAuth'] as bool? ?? true;

    if (needAuth) {
      final token = await TokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    options.headers['Accept'] = 'application/json';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    final options = err.requestOptions;
    final needAuth = options.extra['needAuth'] as bool? ?? true;
    final retryCount = options.extra['retryCount'] as int? ?? 0;

    // Check if 401 Unauthorized and eligible for refresh
    if (response?.statusCode == 401 && needAuth && retryCount < _maxRetries) {
      final refreshToken = await TokenStorage.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Dedicated Dio instance for refresh call to avoid interceptor recursion
          final refreshDio = Dio(
            BaseOptions(
              baseUrl: options.baseUrl.isNotEmpty ? options.baseUrl : ApiEndpoints.baseUrl,
              connectTimeout: ApiEndpoints.connectionTimeout,
              receiveTimeout: ApiEndpoints.receiveTimeout,
            ),
          );

          final refreshResponse = await refreshDio.post(
            ApiEndpoints.refreshToken,
            data: {'refresh': refreshToken},
          );

          if (refreshResponse.statusCode == 200 && refreshResponse.data != null) {
            final data = refreshResponse.data;
            final newAccessToken = data['access'] ?? data['data']?['access'];
            final newRefreshToken = data['refresh'] ?? data['data']?['refresh'];

            if (newAccessToken != null) {
              await TokenStorage.saveTokens(
                accessToken: newAccessToken.toString(),
                refreshToken: newRefreshToken?.toString(),
              );

              // Update header & retry original request
              options.headers['Authorization'] = 'Bearer $newAccessToken';
              options.extra['retryCount'] = retryCount + 1;

              final retryResponse = await dio.fetch(options);
              return handler.resolve(retryResponse);
            }
          }
        } catch (refreshError) {
          if (kDebugMode) {
            debugPrint('⚠️ Token refresh failed: $refreshError');
          }
          await TokenStorage.clearTokens();
        }
      } else {
        await TokenStorage.clearTokens();
      }
    }

    return handler.next(err);
  }
}