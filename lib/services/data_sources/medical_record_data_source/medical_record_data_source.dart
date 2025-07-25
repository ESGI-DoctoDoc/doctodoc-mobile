import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/dtos/update_document_request.dart';

import '../../dtos/upload_document_request.dart';

abstract class MedicalRecordDataSource {
  Future<List<Document>> getDocuments({required int page, String? type});

  Future<Document> getDocumentById(String id);

  Future<DocumentDetailed> getDetailDocumentById(String id);

  Future<void> uploadDocument(UploadDocumentRequest uploadDocumentRequest);

  Future<void> deleteDocument(String id);

  Future<Document> updateDocument(UpdateDocumentRequest updateDocumentRequest);

  Future<List<DocumentTrace>> getDocumentTracesById(String id);
}
