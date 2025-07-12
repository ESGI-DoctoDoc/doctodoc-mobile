import 'dart:async';

import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/services/data_sources/local_auth_data_source/local_auth_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/user_data_source/user_data_source.dart';
import 'package:doctodoc_mobile/services/dtos/update_profile_request.dart';
import 'package:doctodoc_mobile/services/repositories/user_repository/user_repository_event.dart';

import '../../../exceptions/app_exception.dart';
import '../../../models/user.dart';

class UserRepository {
  final UserDataSource userDataSource;
  final LocalAuthDataSource localAuthDataSource;

  UserRepository({
    required this.userDataSource,
    required this.localAuthDataSource,
  });

  final _userRepositoryEventController = StreamController<UserRepositoryEvent>.broadcast();

  Stream<UserRepositoryEvent> get userRepositoryEventStream =>
      _userRepositoryEventController.stream;

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

  Future<List<Patient>> getCloseMembers() async {
    try {
      String? userPatientId = await localAuthDataSource.retrieveUserPatientId();
      if (userPatientId == null) {
        throw UnknownException();
      } else {
        return await userDataSource.getUserCloseMembers(userPatientId);
      }
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> updateProfile(UpdateProfileRequest request) async {
    try {
      Patient patient = await userDataSource.updateProfile(request);
      _userRepositoryEventController.add(UpdatedProfileEvent(updatedProfile: patient));
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> saveFcmToken(String fcmToken) async {
    try {
      await userDataSource.saveFcmToken(fcmToken);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    try {
      await userDataSource.updatePassword(oldPassword, newPassword);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> requestNewPassword(String email) async {
    try {
      await userDataSource.requestNewPassword(email);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> deleteAccount() async {
    try {
      await userDataSource.deleteAccount();
    } catch (error) {
      throw UnknownException();
    }
  }

  dispose() {
    _userRepositoryEventController.close();
  }
}
