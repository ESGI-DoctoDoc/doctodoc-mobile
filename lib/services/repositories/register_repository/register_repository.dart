import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/services/data_sources/register_data_source/register_data_source.dart';

import '../../../exceptions/app_exception.dart';
import '../../../models/patient.dart';
import '../../data_sources/local_auth_data_source/local_auth_data_source.dart';

class RegisterRepository {
  final RegisterDataSource registerDataSource;
  final LocalAuthDataSource localAuthDataSource;

  RegisterRepository({
    required this.registerDataSource,
    required this.localAuthDataSource,
  });

  Future<void> register(String email,
      String password,
      String phoneNumber,) async {
    try {
      await registerDataSource.register(email, password, phoneNumber);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> onBoarding(
    String firstName,
    String lastName,
    String birthdate,
    String gender,
    String? referentDoctorId,
  ) async {
    try {
      Patient patient = await registerDataSource.onBoarding(
        firstName,
        lastName,
        birthdate,
        gender,
        referentDoctorId,
      );

      localAuthDataSource.saveUser(true, patient.id.toString());
    } on DioException catch (error) {
      print(error.response?.data);
      throw UnknownException();
    }
  }
}
