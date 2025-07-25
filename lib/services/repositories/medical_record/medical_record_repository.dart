import 'dart:async';

import 'package:doctodoc_mobile/exceptions/medical_record_exception.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/data_sources/medical_record_data_source/medical_record_data_source.dart';
import 'package:doctodoc_mobile/services/dtos/update_document_request.dart';
import 'package:doctodoc_mobile/services/dtos/upload_document_request.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository_event.dart';

class MedicalRecordRepository {
  final MedicalRecordDataSource medicalRecordDataSource;

  final _medicalRecordRepositoryEventController =
      StreamController<MedicalRecordRepositoryEvent>.broadcast();

  Stream<MedicalRecordRepositoryEvent> get medicalRecordRepositoryEventStream =>
      _medicalRecordRepositoryEventController.stream;

  MedicalRecordRepository({
    required this.medicalRecordDataSource,
  });

  Future<List<Document>> getDocuments({required int page, String? type}) async {
    try {
      return await medicalRecordDataSource.getDocuments(
        page: page,
        type: type,
      );
    } catch (error) {
      throw MedicalRecordException.from(error);
    }
  }

  Future<Document> getDocumentById(String id) async {
    try {
      return await medicalRecordDataSource.getDocumentById(id);
    } catch (error) {
      throw MedicalRecordException.from(error);
    }
  }

  Future<DocumentDetailed> getDetailDocumentById(String id) async {
    try {
      return await medicalRecordDataSource.getDetailDocumentById(id);
    } catch (error) {
      throw MedicalRecordException.from(error);
    }
  }

  Future<List<DocumentTrace>> getDocumentTracesById(String id) async {
    try {
      return await medicalRecordDataSource.getDocumentTracesById(id);
    } catch (error) {
      throw MedicalRecordException.from(error);
    }
  }

  Future<void> uploadDocument(UploadDocumentRequest uploadDocumentRequest) async {
    try {
      await medicalRecordDataSource.uploadDocument(uploadDocumentRequest);
      _medicalRecordRepositoryEventController.add(UploadMedicalRecordDocumentEvent());
    } catch (error) {
      throw MedicalRecordException.from(error);
    }
  }

  Future<void> updateDocument(UpdateDocumentRequest updateDocumentRequest) async {
    try {
      final Document document = await medicalRecordDataSource.updateDocument(updateDocumentRequest);
      _medicalRecordRepositoryEventController.add(UpdateMedicalRecordDocumentEvent(
        id: document.id,
        type: updateDocumentRequest.type,
        filename: document.name,
      ));
    } catch (error) {
      throw MedicalRecordException.from(error);
    }
  }

  Future<void> deleteDocument(String id) async {
    try {
      await medicalRecordDataSource.deleteDocument(id);
      _medicalRecordRepositoryEventController.add(DeleteMedicalRecordDocumentEvent(id: id));
    } catch (error) {
      throw MedicalRecordException.from(error);
    }
  }

  dispose() {
    _medicalRecordRepositoryEventController.close();
  }
}
