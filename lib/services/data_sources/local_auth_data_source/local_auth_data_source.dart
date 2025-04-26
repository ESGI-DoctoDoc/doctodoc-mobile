abstract class LocalAuthDataSource {
  Future<void> saveToken(String token);

  Future<void> destroyToken();

  Future<String?> retrieveToken();

  Future<bool> isFirstLaunch();

  Future<void> saveFirstLaunch();
}
