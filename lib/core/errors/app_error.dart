enum ErrorType {
  network,
  server,
  unauthorized,
  notFound,
  validation,
  timeout,
  storage,
  unknown,
}

class AppError implements Exception {
  final String message;
  final int? statusCode;
  final ErrorType type;
  final dynamic originalError;

  AppError({
    required this.message,
    this.statusCode,
    this.type = ErrorType.unknown,
    this.originalError,
  });

  factory AppError.network([String? msg]) => AppError(
        message: msg ?? 'No internet connection. Please check your network.',
        type: ErrorType.network,
      );

  factory AppError.unauthorized([String? msg]) => AppError(
        message: msg ?? 'Session expired. Please log in again.',
        statusCode: 401,
        type: ErrorType.unauthorized,
      );

  factory AppError.server([String? msg, int? code]) => AppError(
        message: msg ?? 'Server error occurred. Please try again later.',
        statusCode: code ?? 500,
        type: ErrorType.server,
      );

  factory AppError.validation(String msg) => AppError(
        message: msg,
        type: ErrorType.validation,
      );

  @override
  String toString() => 'AppError($type, $statusCode): $message';
}
