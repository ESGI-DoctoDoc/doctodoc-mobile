import 'package:shared_preferences/shared_preferences.dart';

import 'local_auth_data_source.dart';

class SharedPreferencesAuthDataSource implements LocalAuthDataSource {
  static const _tokenKey = 'auth_token';
  static const _userOnBoardingStatusKey = 'user_on_boarding_status';
  static const _userTwoFactorStatusKey = 'user_two_factor_status';
  static const _userPatientId = 'user_patient_id';

  @override
  Future<void> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(_tokenKey, token);
  }

  @override
  Future<String?> retrieveToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_tokenKey);
  }

  @override
  Future<void> destroyToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
  }

  @override
  Future<void> saveHasCompletedTwoFactorAuthentication(bool status) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_userTwoFactorStatusKey, status);
  }

  @override
  Future<bool> hasCompletedTwoFactorAuthentication() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_userTwoFactorStatusKey) ?? false;
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_userOnBoardingStatusKey) ?? false;
  }

  @override
  Future<void> saveUser(bool hasOnboarded, String patientId) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_userOnBoardingStatusKey, hasOnboarded);
    await preferences.setString(_userPatientId, patientId);
  }

  @override
  reset() async {
    final preferences = await SharedPreferences.getInstance();
    await destroyToken();
    await preferences.remove(_userTwoFactorStatusKey);
    await preferences.remove(_userOnBoardingStatusKey);
    await preferences.remove(_userPatientId);
  }
}
