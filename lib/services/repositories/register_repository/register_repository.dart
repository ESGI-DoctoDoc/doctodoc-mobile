import 'package:doctodoc_mobile/services/data_sources/register_data_source/register_data_source.dart';

import '../../../exceptions/app_exception.dart';

class RegisterRepository {
  final RegisterDataSource registerDataSource;

  RegisterRepository({
    required this.registerDataSource,
  });

  Future<void> register(
      String email, String password, String phoneNumber) async {
    try {
      await registerDataSource.register(email, password, phoneNumber);
    } catch (error) {
      throw UnknownException();
    }
  }
}
