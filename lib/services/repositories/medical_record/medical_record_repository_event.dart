abstract class MedicalRecordRepositoryEvent {}

class UploadMedicalRecordDocumentEvent extends MedicalRecordRepositoryEvent {}

class DeleteMedicalRecordDocumentEvent extends MedicalRecordRepositoryEvent {
  final String id;

  DeleteMedicalRecordDocumentEvent({
    required this.id,
  });
}
