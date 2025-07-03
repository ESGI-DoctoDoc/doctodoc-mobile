abstract class CareTrackingRepositoryEvent {}

class UploadCareTrackingDocumentEvent extends CareTrackingRepositoryEvent {
  final String id;

  UploadCareTrackingDocumentEvent({
    required this.id,
  });
}

class UpdateCareTrackingDocumentEvent extends CareTrackingRepositoryEvent {
  final String id;
  final String type;
  final String filename;

  UpdateCareTrackingDocumentEvent({
    required this.id,
    required this.type,
    required this.filename,
  });
}

class DeleteCareTrackingDocumentEvent extends CareTrackingRepositoryEvent {
  final String id;

  DeleteCareTrackingDocumentEvent({
    required this.id,
  });
}
