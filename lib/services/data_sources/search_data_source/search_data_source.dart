import '../../../models/doctor/doctor.dart';

abstract class SearchDataSource {
  Future<List<Doctor>> searchDoctor(String name, String speciality, String languages, int page);
}
