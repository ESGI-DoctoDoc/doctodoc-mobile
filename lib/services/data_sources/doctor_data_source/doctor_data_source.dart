import 'package:doctodoc_mobile/models/doctor/doctor_detailed.dart';

abstract class DoctorDataSource {
  Future<DoctorDetailed> get(String id);

  Future<void> recruit(String firstName, String lastName);
}
