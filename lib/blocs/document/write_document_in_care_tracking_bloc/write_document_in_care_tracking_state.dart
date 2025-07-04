part of 'write_document_in_care_tracking_bloc.dart';

enum UploadDocumentStatus { initial, loading, success, error }

enum DeleteDocumentStatus { initial, loading, success, error }

enum UpdateDocumentStatus { initial, loading, success, error }

enum ShareDocumentStatus { initial, loading, success, error }

class WriteDocumentInCareTrackingState {
  final UploadDocumentStatus uploadStatus;
  final DeleteDocumentStatus deleteStatus;
  final UpdateDocumentStatus updateStatus;
  final ShareDocumentStatus shareStatus;
  final AppException? exception;

  const WriteDocumentInCareTrackingState({
    this.uploadStatus = UploadDocumentStatus.initial,
    this.deleteStatus = DeleteDocumentStatus.initial,
    this.updateStatus = UpdateDocumentStatus.initial,
    this.shareStatus = ShareDocumentStatus.initial,
    this.exception,
  });

  WriteDocumentInCareTrackingState copyWith({
    UploadDocumentStatus? uploadStatus,
    DeleteDocumentStatus? deleteStatus,
    UpdateDocumentStatus? updateStatus,
    ShareDocumentStatus? shareStatus,
    AppException? exception,
  }) {
    return WriteDocumentInCareTrackingState(
      uploadStatus: uploadStatus ?? this.uploadStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      shareStatus: shareStatus ?? this.shareStatus,
      exception: exception ?? this.exception,
    );
  }
}
