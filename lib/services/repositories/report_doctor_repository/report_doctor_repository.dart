import 'dart:async';

import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/services/data_sources/report_doctor_data_source/report_doctor_data_source.dart';

class ReportDoctorRepository {
  final ReportDoctorDataSource reportDoctorDataSource;

  ReportDoctorRepository({
    required this.reportDoctorDataSource,
  });

  Future<void> report(String doctorId, String explanation) async {
    try {
      return await reportDoctorDataSource.report(doctorId, explanation);
    } catch (error) {
      throw UnknownException();
    }
  }
}
