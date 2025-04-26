class AppException implements Exception {
  final String message;

  AppException({
    required this.message,
  });

  static AppException from(dynamic exception) {
    if (exception is AppException) return exception;
    return UnknownException();
  }
}

class UnknownException extends AppException {
  static const errorMessage = 'An unexpected error occurred';

  UnknownException() : super(message: errorMessage);
}