import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/doctor.dart';
import 'package:doctodoc_mobile/services/data_sources/search_data_source/search_data_source.dart';

class RemoteSearchDataSource extends SearchDataSource {
  final Dio dio;

  RemoteSearchDataSource({required this.dio});

  @override
  Future<List<Doctor>> searchDoctor(
      String name, String speciality, String languages, int page) async {
    int defaultSize = 10;
    final response = await dio.get(
        "/patients/doctors/search?name=$name&speciality=$speciality&languages=$languages&page=$page&size=$defaultSize");

    // final response =
    // await dio.get("/patients/doctors/search?name=$name&speciality=infectiologue&page=$page&size=$defaultSize");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => Doctor.fromJson(jsonElement)).toList();
  }
}
