import 'package:doctodoc_mobile/models/speciality.dart';

abstract class SpecialityDataSource {
  Future<List<Speciality>> getAll();
}
