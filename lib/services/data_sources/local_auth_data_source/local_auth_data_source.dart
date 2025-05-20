abstract class LocalAuthDataSource {
  Future<void> saveToken(String token);

  Future<void> destroyToken();

  Future<String?> retrieveToken();

  Future<void> saveHasCompletedTwoFactorAuthentication(bool status);

  Future<bool> hasCompletedTwoFactorAuthentication();

  Future<bool> hasCompletedOnboarding();

  Future<void> saveUser(bool hasOnboarded, String patientId);

  Future<void> reset();

  Future<String?> retrieveUserPatientId();
}
