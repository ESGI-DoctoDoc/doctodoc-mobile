part of 'write_document_bloc.dart';

enum UploadDocumentStatus { initial, loading, success, error }

enum DeleteDocumentStatus { initial, loading, success, error }

enum UpdateDocumentStatus { initial, loading, success, error }

class WriteDocumentState {
  final UploadDocumentStatus uploadStatus;
  final DeleteDocumentStatus deleteStatus;
  final UpdateDocumentStatus updateStatus;
  final AppException? exception;

  const WriteDocumentState({
    this.uploadStatus = UploadDocumentStatus.initial,
    this.deleteStatus = DeleteDocumentStatus.initial,
    this.updateStatus = UpdateDocumentStatus.initial,
    this.exception,
  });

  WriteDocumentState copyWith({
    UploadDocumentStatus? uploadStatus,
    DeleteDocumentStatus? deleteStatus,
    UpdateDocumentStatus? updateStatus,
    AppException? exception,
  }) {
    return WriteDocumentState(
      uploadStatus: uploadStatus ?? this.uploadStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      exception: exception ?? this.exception,
    );
  }
}
