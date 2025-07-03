part of 'display_document_content_bloc.dart';

@immutable
sealed class DisplayDocumentContentEvent {}

class OnGetContentOnMedicalRecord extends DisplayDocumentContentEvent {
  final String id;

  OnGetContentOnMedicalRecord({
    required this.id,
  });
}

class OnGetContentOnCareTracking extends DisplayDocumentContentEvent {
  final String careTrackingId;
  final String id;

  OnGetContentOnCareTracking({
    required this.careTrackingId,
    required this.id,
  });
}
