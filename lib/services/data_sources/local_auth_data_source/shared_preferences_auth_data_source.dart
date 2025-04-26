import 'package:shared_preferences/shared_preferences.dart';

import 'local_auth_data_source.dart';

class SharedPreferencesAuthDataSource implements LocalAuthDataSource {
  static const _tokenKey = 'auth_token';
  static const _firstLaunch = 'first_launch';

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
  Future<bool> isFirstLaunch() async {
    final preferences = await SharedPreferences.getInstance();
    return !(preferences.getBool(_firstLaunch) ?? false);
  }

  @override
  Future<void> saveFirstLaunch() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_firstLaunch, true);
  }
}
