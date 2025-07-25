import 'package:doctodoc_mobile/models/doctor/doctor.dart';

abstract class ReferentDoctorDataSource {
  Future<Doctor?> get();

  Future<Doctor> set(String doctorId);
}
