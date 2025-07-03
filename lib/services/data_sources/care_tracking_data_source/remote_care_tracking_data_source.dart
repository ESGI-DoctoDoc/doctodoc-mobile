import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/care_tracking.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:mime/mime.dart';

import 'care_tracking_data_source.dart';

class RemoteCareTrackingDataSource implements CareTrackingDataSource {
  final Dio dio;

  RemoteCareTrackingDataSource({required this.dio});

  @override
  Future<List<CareTracking>> getAll(int page) async {
    int defaultSize = 10;
    final response = await dio.get("/patients/care-trackings?page=$page&size=$defaultSize");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => CareTracking.fromJson(jsonElement)).toList();
  }

  @override
  Future<CareTrackingDetailed> getById(String id) async {
    final response = await dio.get("/patients/care-trackings/$id");
    return CareTrackingDetailed.fromJson(response.data["data"]);
  }

  @override
  Future<List<Document>> getDocumentsById(String id) async {
    final response = await dio.get("/patients/care-trackings/$id/documents");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => Document.fromJson(jsonElement)).toList();
  }

  @override
  Future<void> uploadDocument(String id, uploadDocumentRequest) async {
    final response = await dio.post(
      "/patients/care-trackings/$id/documents",
      data: jsonEncode({
        "filename": uploadDocumentRequest.filename,
        "type": uploadDocumentRequest.type,
      }),
    );

    await uploadOnS3(uploadDocumentRequest.file, response.data["data"]["id"], id);
  }

  Future<void> uploadOnS3(File file, String id, String careTrackingId) async {
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    final bytes = await file.readAsBytes();

    final response = await dio.get("/patients/care-trackings/${careTrackingId}/upload-url/$id");
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
  Future<Document> getDocumentById(String careTrackingId, String id) async {
    final response = await dio.get("/patients/care-trackings/$careTrackingId/documents/$id");
    return Document.fromJson(response.data["data"]);
  }

  @override
  Future<DocumentDetailed> getDetailDocumentById(careTrackingId, String id) async {
    final response = await dio.get("/patients/care-trackings/$careTrackingId/documents/detail/$id");
    return DocumentDetailed.fromJson(response.data["data"]);
  }

  @override
  Future<List<DocumentTrace>> getDocumentTracesById(String careTrackingId, String id) async {
    final response = await dio.get("/patients/care-trackings/$careTrackingId/documents/$id/traces");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => DocumentTrace.fromJson(jsonElement)).toList();
  }
}
