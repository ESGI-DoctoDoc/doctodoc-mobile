part of 'display_document_content_bloc.dart';

enum DisplayDocumentContentStatus { initial, loading, success, error }

class DisplayDocumentContentState {
  final Document? document;
  final DisplayDocumentContentStatus status;
  final AppException? exception;

  DisplayDocumentContentState({
    this.document,
    this.status = DisplayDocumentContentStatus.initial,
    this.exception,
  });

  DisplayDocumentContentState copyWith({
    DisplayDocumentContentStatus? status,
    Document? document,
    AppException? exception,
  }) {
    return DisplayDocumentContentState(
      status: status ?? this.status,
      document: document ?? this.document,
      exception: exception ?? this.exception,
    );
  }
}
