import 'dart:async';

import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/doctor/doctor.dart';
import 'package:doctodoc_mobile/services/data_sources/referent_doctor_data_source/referent_doctor_data_source.dart';
import 'package:doctodoc_mobile/services/repositories/referent_doctor_repository/referent_doctor_repository_event.dart';

class ReferentDoctorRepository {
  final ReferentDoctorDataSource referentDoctorDataSource;

  final _referentDoctorRepositoryEventController =
      StreamController<ReferentDoctorEvent>.broadcast();

  Stream<ReferentDoctorEvent> get referentDoctorRepositoryEventStream =>
      _referentDoctorRepositoryEventController.stream;

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

  Future<void> set(String doctorId) async {
    try {
      Doctor doctor = await referentDoctorDataSource.set(doctorId);
      _referentDoctorRepositoryEventController.add(SetReferentDoctor(doctor: doctor));
    } catch (error) {
      throw UnknownException();
    }
  }

  dispose() {
    _referentDoctorRepositoryEventController.close();
  }
}
