class UpdateDocumentRequest {
  final String id;
  final String type;
  final String filename;

  UpdateDocumentRequest({
    required this.id,
    required this.type,
    required this.filename,
  });
}
