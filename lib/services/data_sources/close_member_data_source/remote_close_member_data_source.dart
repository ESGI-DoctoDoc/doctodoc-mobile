import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/services/data_sources/close_member_data_source/close_member_data_source.dart';
import 'package:doctodoc_mobile/services/dtos/create_close_member_request.dart';

import '../../../models/patient.dart';

class RemoteCloseMemberDataSource extends CloseMemberDataSource {
  final Dio dio;

  RemoteCloseMemberDataSource({required this.dio});

  @override
  Future<Patient> create(SaveCloseMemberRequest request) async {
    final response = await dio.post(
      "/patients/close-members",
      data: jsonEncode({
        "firstName": request.firstName,
        "lastName": request.lastName,
        "birthdate": request.birthdate,
        "gender": request.gender,
        "email": request.email,
        "phoneNumber": request.phoneNumber,
      }),
    );

    return Patient.fromJson(response.data["data"]);
  }

  @override
  Future<void> delete(String id) async {
    await dio.delete("/patients/close-members/$id");
  }

  @override
  Future<Patient> update(String id, SaveCloseMemberRequest request) async {
    final response = await dio.put(
      "/patients/close-members/$id",
      data: jsonEncode({
        "firstName": request.firstName,
        "lastName": request.lastName,
        "birthdate": request.birthdate,
        "gender": request.gender,
        "email": request.email,
        "phoneNumber": request.phoneNumber,
      }),
    );

    return Patient.fromJson(response.data["data"]);
  }

  @override
  Future<Patient> findById(String id) async {
    final response = await dio.get("/patients/close-members/$id");
    return Patient.fromJson(response.data["data"]);
  }
}
