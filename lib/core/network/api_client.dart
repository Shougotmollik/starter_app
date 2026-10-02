import 'package:api_learning/core/network/api_endpoint.dart';
import 'package:api_learning/core/network/api_interceptor.dart';
import 'package:api_learning/core/network/api_response.dart';
import 'package:api_learning/core/network/network_exceptions.dart';
import 'package:api_learning/utils/app_snackbar.dart';
import 'package:api_learning/utils/internet_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient();
}

class ApiClient {
  late final Dio _dio;

  ApiClient({
    String? baseUrl,
    List<Interceptor>? additionalInterceptors,
    bool enablePrettyLogger = true,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        sendTimeout: ApiEndpoints.sendTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // 1. Auth & Auto Refresh Interceptor
    _dio.interceptors.add(AuthInterceptor(dio: _dio));

    // 2. Optional additional interceptors
    if (additionalInterceptors != null) {
      _dio.interceptors.addAll(additionalInterceptors);
    }

    // 3. Pretty Dio Logger (Active in debug mode)
    if (kDebugMode && enablePrettyLogger) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  Dio get rawDio => _dio;

  /// Performs pre-flight internet check
  Future<bool> _preFlightInternetCheck(
    bool checkInternet,
    bool showFloatingError,
  ) async {
    if (!checkInternet) return true;
    final isConnected = await InternetChecker.hasConnection(
      showError: showFloatingError,
    );
    return isConnected;
  }

  /// GET Request
  Future<ApiResponse<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool needAuth = true,
    bool checkInternet = true,
    bool showFloatingError = false,
    T Function(dynamic data)? responseParser,
  }) async {
    if (!await _preFlightInternetCheck(checkInternet, showFloatingError)) {
      return ApiResponse.error(
        'No internet! Please check your connection.',
        statusCode: -1,
      );
    }

    final effectiveOptions = _mergeOptions(options, needAuth);
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: effectiveOptions,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response, responseParser);
    } on DioException catch (e) {
      return _handleDioError<T>(e, showFloatingError: showFloatingError);
    } catch (e) {
      return _handleGenericError<T>(e, showFloatingError: showFloatingError);
    }
  }

  /// POST Request
  Future<ApiResponse<T>> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool needAuth = true,
    bool checkInternet = true,
    bool showFloatingError = false,
    T Function(dynamic data)? responseParser,
  }) async {
    if (!await _preFlightInternetCheck(checkInternet, showFloatingError)) {
      return ApiResponse.error(
        'No internet! Please check your connection.',
        statusCode: -1,
      );
    }

    final effectiveOptions = _mergeOptions(options, needAuth);
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: effectiveOptions,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response, responseParser);
    } on DioException catch (e) {
      return _handleDioError<T>(e, showFloatingError: showFloatingError);
    } catch (e) {
      return _handleGenericError<T>(e, showFloatingError: showFloatingError);
    }
  }

  /// PUT Request
  Future<ApiResponse<T>> put<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool needAuth = true,
    bool checkInternet = true,
    bool showFloatingError = false,
    T Function(dynamic data)? responseParser,
  }) async {
    if (!await _preFlightInternetCheck(checkInternet, showFloatingError)) {
      return ApiResponse.error(
        'No internet! Please check your connection.',
        statusCode: -1,
      );
    }

    final effectiveOptions = _mergeOptions(options, needAuth);
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: effectiveOptions,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response, responseParser);
    } on DioException catch (e) {
      return _handleDioError<T>(e, showFloatingError: showFloatingError);
    } catch (e) {
      return _handleGenericError<T>(e, showFloatingError: showFloatingError);
    }
  }

  /// PATCH Request
  Future<ApiResponse<T>> patch<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool needAuth = true,
    bool checkInternet = true,
    bool showFloatingError = false,
    T Function(dynamic data)? responseParser,
  }) async {
    if (!await _preFlightInternetCheck(checkInternet, showFloatingError)) {
      return ApiResponse.error(
        'No internet! Please check your connection.',
        statusCode: -1,
      );
    }

    final effectiveOptions = _mergeOptions(options, needAuth);
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: effectiveOptions,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response, responseParser);
    } on DioException catch (e) {
      return _handleDioError<T>(e, showFloatingError: showFloatingError);
    } catch (e) {
      return _handleGenericError<T>(e, showFloatingError: showFloatingError);
    }
  }

  /// DELETE Request
  Future<ApiResponse<T>> delete<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool needAuth = true,
    bool checkInternet = true,
    bool showFloatingError = false,
    T Function(dynamic data)? responseParser,
  }) async {
    if (!await _preFlightInternetCheck(checkInternet, showFloatingError)) {
      return ApiResponse.error(
        'No internet! Please check your connection.',
        statusCode: -1,
      );
    }

    final effectiveOptions = _mergeOptions(options, needAuth);
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: effectiveOptions,
        cancelToken: cancelToken,
      );
      return _parseResponse<T>(response, responseParser);
    } on DioException catch (e) {
      return _handleDioError<T>(e, showFloatingError: showFloatingError);
    } catch (e) {
      return _handleGenericError<T>(e, showFloatingError: showFloatingError);
    }
  }

  /// MULTIPART File Upload (Supports single file, multiple files, and fields)
  Future<ApiResponse<T>> multipart<T>({
    required String path,
    String? fieldName,
    String? filePath,
    List<String>? filePaths,
    Map<String, dynamic>? fields,
    Map<String, dynamic>? queryParameters,
    String method = 'POST',
    bool needAuth = true,
    bool checkInternet = true,
    bool showFloatingError = false,
    ProgressCallback? onSendProgress,
    T Function(dynamic data)? responseParser,
  }) async {
    if (!await _preFlightInternetCheck(checkInternet, showFloatingError)) {
      return ApiResponse.error(
        'No internet! Please check your connection.',
        statusCode: -1,
      );
    }

    try {
      final mapData = <String, dynamic>{};

      if (fields != null) {
        mapData.addAll(fields);
      }

      // Single file
      if (filePath != null && fieldName != null && fieldName.isNotEmpty) {
        mapData[fieldName] = await MultipartFile.fromFile(filePath);
      }

      // Multiple files
      if (filePaths != null && fieldName != null && fieldName.isNotEmpty) {
        final files = <MultipartFile>[];
        for (final path in filePaths) {
          files.add(await MultipartFile.fromFile(path));
        }
        mapData[fieldName] = files;
      }

      final formData = FormData.fromMap(mapData);

      final response = await _dio.request(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: Options(
          method: method.toUpperCase(),
          contentType: 'multipart/form-data',
          extra: {'needAuth': needAuth},
        ),
        onSendProgress: onSendProgress,
      );

      return _parseResponse<T>(response, responseParser);
    } on DioException catch (e) {
      return _handleDioError<T>(e, showFloatingError: showFloatingError);
    } catch (e) {
      return _handleGenericError<T>(e, showFloatingError: showFloatingError);
    }
  }

  Options _mergeOptions(Options? options, bool needAuth) {
    final opts = options ?? Options();
    opts.extra = {...?opts.extra, 'needAuth': needAuth};
    return opts;
  }

  ApiResponse<T> _parseResponse<T>(
    Response response,
    T Function(dynamic data)? parser,
  ) {
    final rawData = response.data;
    if (parser != null) {
      return ApiResponse.success(
        parser(rawData),
        statusCode: response.statusCode,
      );
    }
    return ApiResponse.success(rawData as T, statusCode: response.statusCode);
  }

  ApiResponse<T> _handleDioError<T>(
    DioException error, {
    bool showFloatingError = false,
  }) {
    final networkError = NetworkException.fromDioException(error);
    if (showFloatingError) {
      AppSnackbar.show(message: networkError.message, type: SnackbarType.error);
    }
    return ApiResponse.error(
      networkError.message,
      statusCode: networkError.statusCode,
      data: networkError.data as T?,
    );
  }

  ApiResponse<T> _handleGenericError<T>(
    Object error, {
    bool showFloatingError = false,
  }) {
    final message = error.toString();
    if (showFloatingError) {
      AppSnackbar.show(message: message, type: SnackbarType.error);
    }
    return ApiResponse.error(message);
  }
}
