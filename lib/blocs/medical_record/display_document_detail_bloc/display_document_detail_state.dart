part of 'display_document_detail_bloc.dart';

sealed class DisplayDocumentDetailState {}

class DocumentDetailInitial extends DisplayDocumentDetailState {}

class DocumentDetailLoading extends DisplayDocumentDetailState {}

class DocumentDetailError extends DisplayDocumentDetailState {
  final AppException exception;

  DocumentDetailError({
    required this.exception,
  });
}

class DocumentDetailLoaded extends DisplayDocumentDetailState {
  final DocumentDetailed document;

  DocumentDetailLoaded({
    required this.document,
  });

  DocumentDetailLoaded copyWith({
    DocumentDetailed? document,
  }) {
    return DocumentDetailLoaded(
      document: document ?? this.document,
    );
  }
}
