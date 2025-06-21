part of 'display_medical_record_documents_bloc.dart';

// enum DisplayMedicalRecordDocumentsStatus { initial, initialLoading, loading, success, error }
enum DisplayMedicalRecordDocumentsStatus { initial, loading, success, error }

class DisplayMedicalRecordDocumentsState {
  final DisplayMedicalRecordDocumentsStatus status;
  final List<Document> documents;
  final AppException? exception;

  DisplayMedicalRecordDocumentsState({
    this.status = DisplayMedicalRecordDocumentsStatus.initial,
    this.documents = const [],
    this.exception,
  });

  DisplayMedicalRecordDocumentsState copyWith({
    DisplayMedicalRecordDocumentsStatus? status,
    List<Document>? documents,
    AppException? exception,
  }) {
    return DisplayMedicalRecordDocumentsState(
      status: status ?? this.status,
      documents: documents ?? this.documents,
      exception: exception ?? this.exception,
    );
  }
}
