/// API configuration constants and endpoints.
abstract class ApiEndpoints {
  // Base URLs (Customize per environment e.g. dev, staging, prod)
  static const String baseUrl = 'https://fakestoreapi.com';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  // Endpoints
  static const refreshToken = '';
}