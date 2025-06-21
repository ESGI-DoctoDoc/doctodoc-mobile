import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/data_sources/medical_record_data_source/medical_record_data_source.dart';
import 'package:mime/mime.dart';

import '../../dtos/upload_document_request.dart';

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

  @override
  Future<void> uploadDocument(UploadDocumentRequest uploadDocumentRequest) async {
    final mimeType = lookupMimeType(uploadDocumentRequest.file.path) ?? 'application/octet-stream';

    final bytes = await uploadDocumentRequest.file.readAsBytes();

    final response =
        await dio.get("/patients/medical-record/upload-url/${uploadDocumentRequest.filename}");
    String url = response.data["data"]["url"];

    final dioS3 = Dio(
      BaseOptions(
        headers: {},
      ),
    );

    await dioS3.put(
      url,
      // data: uploadDocumentRequest.file.openRead(),
      data: bytes,
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: mimeType,
          HttpHeaders.contentLengthHeader: bytes.length,
        },
      ),
    );

    await dio.post(
      "/patients/medical-record/documents",
      data: jsonEncode({
        "filename": uploadDocumentRequest.filename,
        "type": uploadDocumentRequest.type,
      }),
    );
  }
}
