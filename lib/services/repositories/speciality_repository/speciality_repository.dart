import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/speciality.dart';
import 'package:doctodoc_mobile/services/data_sources/speciality_data_source/speciality_data_source.dart';

class SpecialityRepository {
  final SpecialityDataSource specialityDataSource;

  SpecialityRepository({
    required this.specialityDataSource,
  });

  Future<List<Speciality>> getAll() async {
    try {
      return await specialityDataSource.getAll();
    } catch (error) {
      throw UnknownException();
    }
  }
}
