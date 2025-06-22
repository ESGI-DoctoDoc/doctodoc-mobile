abstract class MedicalRecordRepositoryEvent {}

class UploadMedicalRecordDocumentEvent extends MedicalRecordRepositoryEvent {}

class UpdateMedicalRecordDocumentEvent extends MedicalRecordRepositoryEvent {
  final String id;
  final String type;
  final String filename;

  UpdateMedicalRecordDocumentEvent({
    required this.id,
    required this.type,
    required this.filename,
  });
}

class DeleteMedicalRecordDocumentEvent extends MedicalRecordRepositoryEvent {
  final String id;

  DeleteMedicalRecordDocumentEvent({
    required this.id,
  });
}
