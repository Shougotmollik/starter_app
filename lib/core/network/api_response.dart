/// Standard generic API result wrapper across the app.
class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final int? statusCode;

  const ApiResponse._({
    required this.isSuccess,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse._(
      isSuccess: true,
      data: data,
      message: message,
      statusCode: statusCode ?? 200,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode, T? data}) {
    return ApiResponse._(
      isSuccess: false,
      message: message,
      statusCode: statusCode ?? -1,
      data: data,
    );
  }

  /// Convenience getters matching custom HTTP clients
  bool get ok => isSuccess;
  String? get error => isSuccess ? null : message;
  bool get hasData => data != null;

  @override
  String toString() => 'ApiResponse(ok: $ok, statusCode: $statusCode, message: $message, data: $data)';
}