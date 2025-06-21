part of 'display_medical_record_documents_bloc.dart';

@immutable
sealed class DisplayMedicalRecordDocumentsEvent {}

class OnGetMedicalRecordDocuments extends DisplayMedicalRecordDocumentsEvent {}

class OnDeleteMedicalRecordDocument extends DisplayMedicalRecordDocumentsEvent {
  final String id;

  OnDeleteMedicalRecordDocument({
    required this.id,
  });
}
