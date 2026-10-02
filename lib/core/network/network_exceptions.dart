import 'package:dio/dio.dart';

/// Normalized exception handling for network and API errors.
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const NetworkException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory NetworkException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return const NetworkException(message: 'Request to the server was cancelled.');
      case DioExceptionType.connectionTimeout:
        return const NetworkException(message: 'Connection timeout. Please check your internet connection.');
      case DioExceptionType.receiveTimeout:
        return const NetworkException(message: 'Receive timeout in connection with API server.');
      case DioExceptionType.sendTimeout:
        return const NetworkException(message: 'Send timeout in connection with API server.');
      case DioExceptionType.connectionError:
        return const NetworkException(message: 'No internet connection or server is unreachable.');
      case DioExceptionType.badCertificate:
        return const NetworkException(message: 'Invalid certificate received from the server.');
      case DioExceptionType.badResponse:
        return NetworkException._handleBadResponse(error.response);
      case DioExceptionType.unknown:
      default:
        return NetworkException(
          message: error.message?.contains('SocketException') ?? false
              ? 'No internet connection available.'
              : 'An unexpected error occurred. Please try again.',
        );
    }
  }

  static NetworkException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    String extractMessage() {
      if (data is Map<String, dynamic>) {
        if (data.containsKey('message') && data['message'] != null) {
          return data['message'].toString();
        }
        if (data.containsKey('error') && data['error'] != null) {
          return data['error'].toString();
        }
      }
      return '';
    }

    final serverMessage = extractMessage();

    switch (statusCode) {
      case 400:
        return NetworkException(
          message: serverMessage.isNotEmpty ? serverMessage : 'Bad Request. Please check your input.',
          statusCode: statusCode,
          data: data,
        );
      case 401:
        return NetworkException(
          message: serverMessage.isNotEmpty ? serverMessage : 'Unauthorized. Please login again.',
          statusCode: statusCode,
          data: data,
        );
      case 403:
        return NetworkException(
          message: serverMessage.isNotEmpty ? serverMessage : 'Access forbidden. You do not have permission.',
          statusCode: statusCode,
          data: data,
        );
      case 404:
        return NetworkException(
          message: serverMessage.isNotEmpty ? serverMessage : 'Requested resource was not found.',
          statusCode: statusCode,
          data: data,
        );
      case 409:
        return NetworkException(
          message: serverMessage.isNotEmpty ? serverMessage : 'Conflict occurred. Resource already exists.',
          statusCode: statusCode,
          data: data,
        );
      case 422:
        return NetworkException(
          message: serverMessage.isNotEmpty ? serverMessage : 'Validation error. Please verify the submitted data.',
          statusCode: statusCode,
          data: data,
        );
      case 500:
      case 502:
      case 503:
        return NetworkException(
          message: serverMessage.isNotEmpty ? serverMessage : 'Internal server error. Please try again later.',
          statusCode: statusCode,
          data: data,
        );
      default:
        return NetworkException(
          message: serverMessage.isNotEmpty ? serverMessage : 'Received invalid status code: $statusCode',
          statusCode: statusCode,
          data: data,
        );
    }
  }

  @override
  String toString() => message;
}