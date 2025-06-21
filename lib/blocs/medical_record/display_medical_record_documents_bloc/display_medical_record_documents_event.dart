part of 'display_medical_record_documents_bloc.dart';

@immutable
sealed class DisplayMedicalRecordDocumentsEvent {}

class OnGetMedicalRecordDocuments extends DisplayMedicalRecordDocumentsEvent {}

class OnGetMedicalRecordDocument extends DisplayMedicalRecordDocumentsEvent {
  final String id;

  OnGetMedicalRecordDocument({
    required this.id,
  });
}
