import '../../../models/user.dart';

abstract class UserDataSource {
  Future<User> getUserPatient(String userPatientId);
}
