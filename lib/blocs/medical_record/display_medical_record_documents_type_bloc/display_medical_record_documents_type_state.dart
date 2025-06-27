part of 'display_medical_record_documents_type_bloc.dart';

enum DisplayMedicalRecordDocumentsTypeStatus { initial, initialLoading, loading, success, error }

class DisplayMedicalRecordDocumentsTypeState {
  final DisplayMedicalRecordDocumentsTypeStatus status;
  final int page;
  final bool isLoadingMore;
  final String type;
  final List<Document> documents;
  final AppException? exception;

  DisplayMedicalRecordDocumentsTypeState({
    this.status = DisplayMedicalRecordDocumentsTypeStatus.initial,
    this.page = -1,
    this.isLoadingMore = true,
    this.type = '',
    this.documents = const [],
    this.exception,
  });

  DisplayMedicalRecordDocumentsTypeState copyWith({
    DisplayMedicalRecordDocumentsTypeStatus? status,
    int? page,
    bool? isLoadingMore,
    String? type,
    List<Document>? documents,
    AppException? exception,
  }) {
    return DisplayMedicalRecordDocumentsTypeState(
      status: status ?? this.status,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      type: type ?? this.type,
      documents: documents ?? this.documents,
      exception: exception ?? this.exception,
    );
  }
}
