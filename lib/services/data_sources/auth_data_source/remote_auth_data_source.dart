import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../models/auth.dart';
import '../../../models/user.dart';
import 'auth_data_source.dart';

class RemoteAuthDataSource extends AuthDataSource {
  final Dio dio;

  RemoteAuthDataSource({required this.dio});

  @override
  Future<Auth> login(String email, String password) async {
    final response = await dio.post(
      "/patients/login",
      data: jsonEncode({
        "identifier": email,
        "password": password,
        "verificationUrl": dotenv.env['VERIFICATION_URL']
      }),
    );

    return Auth.fromJson(response.data["data"]);
  }

  @override
  Future<User> validateDoubleAuthCode(String doubleAuthCode) async {
    final response = await dio.post(
      "/patients/validate-double-auth",
      data: jsonEncode({
        "doubleAuthCode": doubleAuthCode,
      }),
    );

    return User.fromJson(response.data["data"]);
  }
}
