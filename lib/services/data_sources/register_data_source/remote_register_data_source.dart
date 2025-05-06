import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/services/data_sources/register_data_source/register_data_source.dart';

class RemoteRegisterDataSource extends RegisterDataSource {
  final Dio dio;

  RemoteRegisterDataSource({required this.dio});

  @override
  Future<void> register(
      String email, String password, String phoneNumber) async {
    await dio.post(
      "/patients/register",
      data: jsonEncode({
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
      }),
    );
  }
}
