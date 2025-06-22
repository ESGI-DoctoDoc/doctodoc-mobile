import 'package:doctodoc_mobile/models/document.dart';

import '../../dtos/upload_document_request.dart';

abstract class MedicalRecordDataSource {
  Future<List<Document>> getAll();

  Future<Document> getDocumentById(String id);

  Future<DocumentDetailed> getDetailDocumentById(String id);

  Future<void> uploadDocument(UploadDocumentRequest uploadDocumentRequest);

  Future<void> deleteDocument(String id);
}
