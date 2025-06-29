import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/doctor/doctor_detailed.dart';
import 'package:doctodoc_mobile/services/data_sources/doctor_data_source/doctor_data_source.dart';

class RemoteDoctorDataSource extends DoctorDataSource {
  final Dio dio;

  RemoteDoctorDataSource({required this.dio});

  @override
  Future<DoctorDetailed> get(String id) async {
    final response = await dio.get("/patients/doctors/$id");
    return DoctorDetailed.fromJson(response.data["data"]);
  }

  @override
  Future<void> recruit(String firstName, String lastName) async {
    await dio.post("/doctor-recruitment",
        data: jsonEncode({
          "firstName": firstName,
          "lastName": lastName,
        }));
  }
}
