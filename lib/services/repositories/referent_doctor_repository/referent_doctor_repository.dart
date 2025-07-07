import 'dart:async';

import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/doctor/doctor.dart';
import 'package:doctodoc_mobile/services/data_sources/referent_doctor_data_source/referent_doctor_data_source.dart';

class ReferentDoctorRepository {
  final ReferentDoctorDataSource referentDoctorDataSource;

  ReferentDoctorRepository({
    required this.referentDoctorDataSource,
  });

  Future<Doctor?> get() async {
    try {
      return await referentDoctorDataSource.get();
    } catch (error) {
      throw UnknownException();
    }
  }
}
