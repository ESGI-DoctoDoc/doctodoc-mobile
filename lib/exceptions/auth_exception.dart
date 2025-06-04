import 'package:dio/dio.dart';

import 'app_exception.dart';

class AuthException extends AppException {
  static const defaultCode = 'error.auth';

  AuthException({super.code = defaultCode});

  static AppException from(dynamic exception) {
    if (exception is AppException) return exception;
    if (exception is DioException) {
      if(exception.response?.data is Map<String, dynamic>) {
        final data = exception.response!.data as Map<String, dynamic>;
        if (data.containsKey('code')) {
          return AuthException(code: data['code']);
        }
      }
    }
    return AuthException(code: defaultCode);
  }
}