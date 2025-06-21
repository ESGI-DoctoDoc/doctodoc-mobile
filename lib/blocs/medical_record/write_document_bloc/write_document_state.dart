part of 'write_document_bloc.dart';

enum UploadDocumentStatus { initial, loading, success, error }

enum DeleteDocumentStatus { initial, loading, success, error }

class WriteDocumentState {
  final UploadDocumentStatus uploadStatus;
  final DeleteDocumentStatus deleteStatus;
  final AppException? exception;

  const WriteDocumentState({
    this.uploadStatus = UploadDocumentStatus.initial,
    this.deleteStatus = DeleteDocumentStatus.initial,
    this.exception,
  });

  WriteDocumentState copyWith({
    UploadDocumentStatus? uploadStatus,
    DeleteDocumentStatus? deleteStatus,
    AppException? exception,
  }) {
    return WriteDocumentState(
      uploadStatus: uploadStatus ?? this.uploadStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      exception: exception ?? this.exception,
    );
  }
}
