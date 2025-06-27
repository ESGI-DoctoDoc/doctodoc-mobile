part of 'display_medical_record_documents_type_bloc.dart';

@immutable
sealed class DisplayMedicalRecordDocumentsTypeEvent {}

class OnGetInitialMedicalRecordTypeDocuments extends DisplayMedicalRecordDocumentsTypeEvent {
  final String? type;

  OnGetInitialMedicalRecordTypeDocuments({this.type});
}

class OnGetNextMedicalRecordTypeDocuments extends DisplayMedicalRecordDocumentsTypeEvent {
  final String? type;

  OnGetNextMedicalRecordTypeDocuments({this.type});
}

class OnUpdateMedicalRecordTypeDocument extends DisplayMedicalRecordDocumentsTypeEvent {
  final String id;
  final String type;
  final String filename;

  OnUpdateMedicalRecordTypeDocument({
    required this.id,
    required this.type,
    required this.filename,
  });
}

class OnDeleteMedicalRecordTypeDocument extends DisplayMedicalRecordDocumentsTypeEvent {
  final String id;

  OnDeleteMedicalRecordTypeDocument({
    required this.id,
  });
}
