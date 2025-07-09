import 'package:dio/dio.dart';
import 'app_exception.dart';

class ReferentDoctorException extends AppException {
  static const defaultCode = 'error.referent_doctor';
  ReferentDoctorException({super.code = defaultCode});

  static AppException from(dynamic exception) {
    if (exception is AppException) return exception;
    if (exception is DioException) {
      if (exception.response?.data is Map<String, dynamic>) {
        final data = exception.response!.data as Map<String, dynamic>;
        if (data.containsKey('code')) {
          return ReferentDoctorException(code: data['code']);
        }
      }
    }
    return ReferentDoctorException(code: defaultCode);
  }
}
