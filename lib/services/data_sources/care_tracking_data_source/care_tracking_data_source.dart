import 'package:doctodoc_mobile/models/care_tracking.dart';
import 'package:doctodoc_mobile/models/document.dart';

abstract class CareTrackingDataSource {
  Future<List<CareTracking>> getAll(int page);

  Future<CareTrackingDetailed> getById(String id);

  Future<void> uploadDocument(String id, uploadDocumentRequest);

  Future<List<Document>> getDocumentsById(String id);
}
