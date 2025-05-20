import 'package:doctodoc_mobile/models/patient.dart';

import '../../../models/user.dart';

abstract class UserDataSource {
  Future<User> getUserPatient(String userPatientId);

  Future<List<Patient>> getUserCloseMembers(String userPatientId);
}
