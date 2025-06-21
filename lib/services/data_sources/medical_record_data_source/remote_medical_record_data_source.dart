import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/data_sources/medical_record_data_source/medical_record_data_source.dart';

class RemoteMedicalRecordDataSource implements MedicalRecordDataSource {
  final Dio dio;

  RemoteMedicalRecordDataSource({required this.dio});

  @override
  Future<List<Document>> getAll() async {
    final response = await dio.get("/patients/medical-record/documents");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => Document.fromJson(jsonElement)).toList();
  }

  @override
  Future<Document> getDocumentById(String id) async {
    final response = await dio.get("/patients/medical-record/documents/$id");
    return Document.fromJson(response.data["data"]);
  }
}
