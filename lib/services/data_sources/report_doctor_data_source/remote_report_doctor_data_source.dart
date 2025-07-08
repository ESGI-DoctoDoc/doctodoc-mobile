import 'dart:convert';

import 'package:dio/dio.dart';

import 'report_doctor_data_source.dart';

class RemoteReportDoctorDataSource implements ReportDoctorDataSource {
  final Dio dio;

  RemoteReportDoctorDataSource({
    required this.dio,
  });

  @override
  Future<void> report(String doctorId, String explanation) async {
    await dio.post(
      "/patients/report-doctor",
      data: jsonEncode({
        "doctorId": doctorId,
        "explanation": explanation,
      }),
    );
  }
}
