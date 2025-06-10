import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/doctor/doctor_detailed.dart';
import 'package:doctodoc_mobile/services/data_sources/doctor_data_source/doctor_data_source.dart';

class RemoteDoctorDataSource extends DoctorDataSource {
  final Dio dio;

  RemoteDoctorDataSource({required this.dio});

  @override
  Future<DoctorDetailed> get(String id) async {
    final response = await dio.get("/patients/doctors/$id");
    return DoctorDetailed.fromJson(response.data["data"]);
  }
}
