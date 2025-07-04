part of 'display_document_historic_bloc.dart';

@immutable
sealed class DisplayDocumentHistoricEvent {}

class OnGetDocumentTracesInMedicalRecord extends DisplayDocumentHistoricEvent {
  final String id;

  OnGetDocumentTracesInMedicalRecord({
    required this.id,
  });
}

class OnGetDocumentTracesInCareTracking extends DisplayDocumentHistoricEvent {
  final String careTrackingId;
  final String id;

  OnGetDocumentTracesInCareTracking({
    required this.careTrackingId,
    required this.id,
  });
}
