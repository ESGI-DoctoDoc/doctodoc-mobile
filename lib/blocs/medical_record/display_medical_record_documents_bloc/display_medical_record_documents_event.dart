part of 'display_medical_record_documents_bloc.dart';

@immutable
sealed class DisplayMedicalRecordDocumentsEvent {}

class OnGetMedicalRecordDocuments extends DisplayMedicalRecordDocumentsEvent {}

class OnUpdateMedicalRecordDocument extends DisplayMedicalRecordDocumentsEvent {
  final String id;
  final String type;
  final String filename;

  OnUpdateMedicalRecordDocument({
    required this.id,
    required this.type,
    required this.filename,
  });
}

class OnDeleteMedicalRecordDocument extends DisplayMedicalRecordDocumentsEvent {
  final String id;

  OnDeleteMedicalRecordDocument({
    required this.id,
  });
}
