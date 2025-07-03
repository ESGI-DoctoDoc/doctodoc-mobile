import 'dart:async';

import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/care_tracking.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/data_sources/care_tracking_data_source/care_tracking_data_source.dart';
import 'package:doctodoc_mobile/services/dtos/update_document_request.dart';
import 'package:doctodoc_mobile/services/dtos/upload_document_request.dart';

import 'care_tracking_repository_event.dart';

class CareTrackingRepository {
  final CareTrackingDataSource careTrackingDataSource;

  CareTrackingRepository({
    required this.careTrackingDataSource,
  });

  final _careTrackingRepositoryEventController =
      StreamController<CareTrackingRepositoryEvent>.broadcast();

  Stream<CareTrackingRepositoryEvent> get careTrackingRepositoryEventStream =>
      _careTrackingRepositoryEventController.stream;

  Future<List<CareTracking>> getAll(int page) async {
    try {
      return await careTrackingDataSource.getAll(page);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<CareTrackingDetailed> getById(String id) async {
    try {
      return await careTrackingDataSource.getById(id);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<List<Document>> getDocumentsById(String id) async {
    try {
      return await careTrackingDataSource.getDocumentsById(id);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> uploadDocument(String id, UploadDocumentRequest uploadDocumentRequest) async {
    try {
      await careTrackingDataSource.uploadDocument(id, uploadDocumentRequest);
      _careTrackingRepositoryEventController.add(UploadCareTrackingDocumentEvent(
        id: id,
      ));
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<Document> getDocumentById(String careTrackingId, String id) async {
    try {
      return await careTrackingDataSource.getDocumentById(careTrackingId, id);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<DocumentDetailed> getDetailDocumentById(String careTrackingId, String id) async {
    try {
      return await careTrackingDataSource.getDetailDocumentById(careTrackingId, id);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<List<DocumentTrace>> getDocumentTracesById(String careTrackingId, String id) async {
    try {
      return await careTrackingDataSource.getDocumentTracesById(careTrackingId, id);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> deleteDocument(String careTrackingId, String id) async {
    try {
      await careTrackingDataSource.deleteDocument(careTrackingId, id);
      _careTrackingRepositoryEventController.add(DeleteCareTrackingDocumentEvent(id: id));
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> updateDocument(
      String careTrackingId, UpdateDocumentRequest updateDocumentRequest) async {
    try {
      final Document document =
          await careTrackingDataSource.updateDocument(careTrackingId, updateDocumentRequest);
      _careTrackingRepositoryEventController.add(UpdateCareTrackingDocumentEvent(
        id: document.id,
        type: updateDocumentRequest.type,
        filename: document.name,
      ));
    } catch (error) {
      throw UnknownException();
    }
  }

  dispose() {
    _careTrackingRepositoryEventController.close();
  }
}
