import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/speciality.dart';
import 'package:doctodoc_mobile/services/data_sources/speciality_data_source/speciality_data_source.dart';

class RemoteSpecialityDataSource extends SpecialityDataSource {
  final Dio dio;

  RemoteSpecialityDataSource({required this.dio});

  @override
  Future<List<Speciality>> getAll() async {
    final response = await dio.get("/doctors/specialities");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => Speciality.fromJson(jsonElement)).toList();
  }
}
