import 'package:doctodoc_mobile/services/data_sources/local_auth_data_source/local_auth_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/user_data_source/user_data_source.dart';

import '../../../exceptions/app_exception.dart';
import '../../../models/user.dart';

class UserRepository {
  final UserDataSource userDataSource;
  final LocalAuthDataSource localAuthDataSource;

  UserRepository({
    required this.userDataSource,
    required this.localAuthDataSource,
  });

  Future<User> getUser() async {
    try {
      String? userPatientId = await localAuthDataSource.retrieveUserPatientId();
      if (userPatientId == null) {
        throw UnknownException();
      } else {
        return await userDataSource.getUserPatient(userPatientId);
      }
    } catch (error) {
      throw UnknownException();
    }
  }
}
