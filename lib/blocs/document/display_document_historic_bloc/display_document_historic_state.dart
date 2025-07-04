part of 'display_document_historic_bloc.dart';

sealed class DisplayDocumentHistoricState {}

class DocumentHistoricInitial extends DisplayDocumentHistoricState {}

class DocumentHistoricLoading extends DisplayDocumentHistoricState {}

class DocumentHistoricError extends DisplayDocumentHistoricState {
  final AppException exception;

  DocumentHistoricError({
    required this.exception,
  });
}

class DocumentHistoricLoaded extends DisplayDocumentHistoricState {
  final List<DocumentTrace> traces;

  DocumentHistoricLoaded({
    required this.traces,
  });

  DocumentHistoricLoaded copyWith({
    List<DocumentTrace>? traces,
  }) {
    return DocumentHistoricLoaded(
      traces: traces ?? this.traces,
    );
  }
}
