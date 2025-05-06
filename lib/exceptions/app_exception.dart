class AppException implements Exception {
  final String code;

  AppException({
    required this.code,
  });

  static AppException from(dynamic exception) {
    if (exception is AppException) return exception;
    return UnknownException();
  }
}

class UnknownException extends AppException {
  static const defaultCode = 'error.unexpected';

  UnknownException() : super(code: defaultCode);
}