import 'package:doctodoc_mobile/models/doctor/doctor.dart';
import 'package:doctodoc_mobile/services/data_sources/search_data_source/search_data_source.dart';

import '../../../exceptions/auth_exception.dart';

class SearchRepository {
  final SearchDataSource searchDataSource;

  SearchRepository({
    required this.searchDataSource,
  });

  Future<List<Doctor>> searchDoctor(
      String name, String speciality, String languages, int page) async {
    try {
      return await searchDataSource.searchDoctor(name, speciality, languages, page);
    } catch (error) {
      throw AuthException.from(error);
    }
  }
}
