part of 'upload_document_bloc.dart';

enum UploadDocumentStatus { initial, loading, success, error }

class UploadDocumentState {
  final UploadDocumentStatus status;
  final AppException? exception;

  UploadDocumentState({
    this.status = UploadDocumentStatus.initial,
    this.exception,
  });

  UploadDocumentState copyWith({
    UploadDocumentStatus? status,
    AppException? exception,
  }) {
    return UploadDocumentState(
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}
