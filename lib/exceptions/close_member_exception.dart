import 'package:dio/dio.dart';
import 'app_exception.dart';

class CloseMemberException extends AppException {
  static const defaultCode = 'error.close_member';
  CloseMemberException({super.code = defaultCode});

  static AppException from(dynamic exception) {
    if (exception is AppException) return exception;
    if (exception is DioException) {
      if (exception.response?.data is Map<String, dynamic>) {
        final data = exception.response!.data as Map<String, dynamic>;
        if (data.containsKey('code')) {
          return CloseMemberException(code: data['code']);
        }
      }
    }
    return CloseMemberException(code: defaultCode);
  }
}
