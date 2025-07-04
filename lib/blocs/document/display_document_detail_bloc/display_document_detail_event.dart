part of 'display_document_detail_bloc.dart';

@immutable
sealed class DisplayDocumentDetailEvent {}

class OnGetDocumentDetailInMedicalRecord extends DisplayDocumentDetailEvent {
  final String id;

  OnGetDocumentDetailInMedicalRecord({
    required this.id,
  });
}

class OnGetDocumentDetailInCareTracking extends DisplayDocumentDetailEvent {
  final String careTrackingId;
  final String id;

  OnGetDocumentDetailInCareTracking({
    required this.careTrackingId,
    required this.id,
  });
}
