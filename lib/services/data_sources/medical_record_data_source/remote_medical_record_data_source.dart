import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/data_sources/medical_record_data_source/medical_record_data_source.dart';
import 'package:doctodoc_mobile/services/dtos/update_document_request.dart';
import 'package:mime/mime.dart';

import '../../dtos/upload_document_request.dart';

class RemoteMedicalRecordDataSource implements MedicalRecordDataSource {
  final Dio dio;

  RemoteMedicalRecordDataSource({required this.dio});

  @override
  Future<List<Document>> getDocuments({required int page, String? type}) async {
    int defaultSize = 10;

    String request = "/patients/medical-record/documents?page=$page&size=$defaultSize";
    if (type != null) {
      request = "$request&type=$type";
    }
    final response = await dio.get(request);

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => Document.fromJson(jsonElement)).toList();
  }

  @override
  Future<Document> getDocumentById(String id) async {
    final response = await dio.get("/patients/medical-record/documents/$id");
    return Document.fromJson(response.data["data"]);
  }

  @override
  Future<DocumentDetailed> getDetailDocumentById(String id) async {
    final response = await dio.get("/patients/medical-record/documents/detail/$id");
    return DocumentDetailed.fromJson(response.data["data"]);
  }

  @override
  Future<void> uploadDocument(UploadDocumentRequest uploadDocumentRequest) async {
    final response = await dio.post(
      "/patients/medical-record/documents",
      data: jsonEncode({
        "filename": uploadDocumentRequest.filename,
        "type": uploadDocumentRequest.type,
      }),
    );

    await uploadOnS3(uploadDocumentRequest.file, response.data["data"]["id"]);
  }

  Future<void> uploadOnS3(File file, String id) async {
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    final bytes = await file.readAsBytes();

    final response = await dio.get("/patients/medical-record/upload-url/$id");
    String url = response.data["data"]["url"];

    final dioS3 = Dio(
      BaseOptions(
        headers: {},
      ),
    );

    await dioS3.put(
      url,
      data: bytes,
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: mimeType,
          HttpHeaders.contentLengthHeader: bytes.length,
        },
      ),
    );
  }

  @override
  Future<void> deleteDocument(String id) async {
    await dio.delete("/patients/medical-record/documents/$id");
  }

  @override
  Future<Document> updateDocument(UpdateDocumentRequest updateDocumentRequest) async {
    final response = await dio.patch(
      "/patients/medical-record/documents/${updateDocumentRequest.id}",
      data: jsonEncode({
        "filename": updateDocumentRequest.filename,
        "type": updateDocumentRequest.type,
      }),
    );

    return Document.fromJson(response.data["data"]);
  }
}
