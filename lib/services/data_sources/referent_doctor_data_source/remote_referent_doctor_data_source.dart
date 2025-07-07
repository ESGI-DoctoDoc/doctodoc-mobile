import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/doctor/doctor.dart';

import 'referent_doctor_data_source.dart';

class RemoteReferentDoctorDataSource implements ReferentDoctorDataSource {
  final Dio dio;

  RemoteReferentDoctorDataSource({
    required this.dio,
  });

  @override
  Future<Doctor?> get() async {
    final response = await dio.get("/patients/referent-doctor");
    if (response.data["data"] == null) {
      return null;
    } else {
      return Doctor.fromJson(response.data["data"]);
    }
  }

  @override
  Future<Doctor> set(String doctorId) async {
    final response = await dio.post("/patients/referent-doctor",
        data: jsonEncode({
          "doctorId": doctorId,
        }));
    return Doctor.fromJson(response.data["data"]);
  }
}
