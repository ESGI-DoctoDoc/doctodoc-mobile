import 'package:doctodoc_mobile/services/dtos/create_close_member_request.dart';

import '../../../models/patient.dart';

abstract class CloseMemberDataSource {
  Future<Patient> create(SaveCloseMemberRequest request);

  Future<Patient> update(String id, SaveCloseMemberRequest request);

  Future<Patient> findById(String id);

  Future<void> delete(String id);
}
