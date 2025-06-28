part of 'display_document_historic_bloc.dart';

@immutable
sealed class DisplayDocumentHistoricEvent {}

class OnGetDocumentTraces extends DisplayDocumentHistoricEvent {
  final String id;

  OnGetDocumentTraces({
    required this.id,
  });
}
