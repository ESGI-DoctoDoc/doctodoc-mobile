import 'package:doctodoc_mobile/models/doctor/doctor_detailed.dart';
import 'package:doctodoc_mobile/services/data_sources/doctor_data_source/doctor_data_source.dart';

import '../../../exceptions/auth_exception.dart';

class DoctorRepository {
  final DoctorDataSource doctorDataSource;

  DoctorRepository({
    required this.doctorDataSource,
  });

  Future<DoctorDetailed> get(String id) async {
    try {
      return await doctorDataSource.get(id);
    } catch (error) {
      print(error.toString());
      throw AuthException.from(error);
    }
  }
}
