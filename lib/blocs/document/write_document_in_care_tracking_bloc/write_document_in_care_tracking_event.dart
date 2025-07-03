part of 'write_document_in_care_tracking_bloc.dart';

@immutable
sealed class WriteDocumentInCareTrackingEvent {}

class OnUploadDocument extends WriteDocumentInCareTrackingEvent {
  final String id;
  final File file;
  final String type;
  final String filename;

  OnUploadDocument({
    required this.id,
    required this.file,
    required this.type,
    required this.filename,
  });
}

class OnDeleteDocument extends WriteDocumentInCareTrackingEvent {
  final String id;

  OnDeleteDocument({
    required this.id,
  });
}

class OnUpdateDocument extends WriteDocumentInCareTrackingEvent {
  final String id;
  final String type;
  final String filename;

  OnUpdateDocument({
    required this.id,
    required this.type,
    required this.filename,
  });
}
