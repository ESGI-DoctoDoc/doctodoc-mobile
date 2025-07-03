abstract class CareTrackingRepositoryEvent {}

class UploadCareTrackingDocumentEvent extends CareTrackingRepositoryEvent {
  final String id;

  UploadCareTrackingDocumentEvent({
    required this.id,
  });
}

class UpdateMedicalRecordDocumentEvent extends CareTrackingRepositoryEvent {
  final String id;
  final String type;
  final String filename;

  UpdateMedicalRecordDocumentEvent({
    required this.id,
    required this.type,
    required this.filename,
  });
}

class DeleteMedicalRecordDocumentEvent extends CareTrackingRepositoryEvent {
  final String id;

  DeleteMedicalRecordDocumentEvent({
    required this.id,
  });
}
