part of 'display_medical_record_documents_bloc.dart';

enum DisplayMedicalRecordDocumentsStatus { initial, initialLoading, loading, success, error }

class DisplayMedicalRecordDocumentsState {
  final DisplayMedicalRecordDocumentsStatus status;
  final int page;
  final bool isLoadingMore;
  final List<Document> documents;
  final AppException? exception;

  DisplayMedicalRecordDocumentsState({
    this.status = DisplayMedicalRecordDocumentsStatus.initial,
    this.page = -1,
    this.isLoadingMore = true,
    this.documents = const [],
    this.exception,
  });

  DisplayMedicalRecordDocumentsState copyWith({
    DisplayMedicalRecordDocumentsStatus? status,
    int? page,
    bool? isLoadingMore,
    List<Document>? documents,
    AppException? exception,
  }) {
    return DisplayMedicalRecordDocumentsState(
      status: status ?? this.status,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      documents: documents ?? this.documents,
      exception: exception ?? this.exception,
    );
  }
}
