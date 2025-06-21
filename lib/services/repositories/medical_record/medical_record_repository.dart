import 'dart:async';

import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/data_sources/medical_record_data_source/medical_record_data_source.dart';
import 'package:doctodoc_mobile/services/dtos/upload_document_request.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository_event.dart';

import '../../../exceptions/app_exception.dart';

class MedicalRecordRepository {
  final MedicalRecordDataSource medicalRecordDataSource;

  final _medicalRecordRepositoryEventController =
      StreamController<MedicalRecordRepositoryEvent>.broadcast();

  Stream<MedicalRecordRepositoryEvent> get medicalRecordRepositoryEventStream =>
      _medicalRecordRepositoryEventController.stream;

  MedicalRecordRepository({
    required this.medicalRecordDataSource,
  });

  Future<List<Document>> getAll() async {
    try {
      return await medicalRecordDataSource.getAll();
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<Document> getDocumentById(String id) async {
    try {
      return await medicalRecordDataSource.getDocumentById(id);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> uploadDocument(UploadDocumentRequest uploadDocumentRequest) async {
    try {
      await medicalRecordDataSource.uploadDocument(uploadDocumentRequest);
      _medicalRecordRepositoryEventController.add(UploadMedicalRecordDocumentEvent());
    } catch (error) {
      throw UnknownException();
    }
  }

  dispose() {
    _medicalRecordRepositoryEventController.close();
  }
}
