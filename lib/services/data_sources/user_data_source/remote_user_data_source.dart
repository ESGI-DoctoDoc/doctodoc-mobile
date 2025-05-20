import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/models/user.dart';
import 'package:doctodoc_mobile/services/data_sources/user_data_source/user_data_source.dart';

class RemoteUserDataSource implements UserDataSource {
  final Dio dio;

  RemoteUserDataSource({required this.dio});

  @override
  Future<User> getUserPatient(String userPatientId) async {
    final response = await dio.get("/patients/user/infos");
    return User.fromJson(response.data["data"]);
  }

  @override
  Future<List<Patient>> getUserCloseMembers(String userPatientId) async {
    final response = await dio.get("/patients/close-members");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => Patient.fromJson(jsonElement)).toList();
  }
}
