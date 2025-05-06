import 'dart:async';

import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/user.dart';

import '../../../models/auth.dart';
import '../../data_sources/auth_data_source/auth_data_source.dart';
import '../../data_sources/local_auth_data_source/local_auth_data_source.dart';

class AuthRepository {
  final AuthDataSource authDataSource;
  final LocalAuthDataSource localAuthDataSource;

  AuthRepository({
    required this.authDataSource,
    required this.localAuthDataSource,
  });

  Future<void> login(String email, String password) async {
    try {
      Auth auth = await authDataSource.login(email, password);
      localAuthDataSource.saveToken(auth.token);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> validateDoubleAuthCode(String doubleAuthCode) async {
    try {
      User user = await authDataSource.validateDoubleAuthCode(doubleAuthCode);
      localAuthDataSource.saveUser(user);
    } catch (error) {
      throw UnknownException();
    }
  }
}
