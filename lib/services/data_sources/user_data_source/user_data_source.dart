import 'package:doctodoc_mobile/models/patient.dart';

import '../../../models/user.dart';
import '../../dtos/update_profile_request.dart';

abstract class UserDataSource {
  Future<User> getUserPatient(String userPatientId);

  Future<List<Patient>> getUserCloseMembers(String userPatientId);

  Future<Patient> updateProfile(UpdateProfileRequest request);
}
