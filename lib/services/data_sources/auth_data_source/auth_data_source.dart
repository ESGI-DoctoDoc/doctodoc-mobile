import '../../../models/auth.dart';
import '../../../models/user.dart';

abstract class AuthDataSource {
  Future<Auth> login(String email, String password);
  Future<User> validateDoubleAuthCode(String doubleAuthCode);
}
