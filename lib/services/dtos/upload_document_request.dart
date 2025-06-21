import 'dart:io';

class UploadDocumentRequest {
  final File file;
  final String type;
  final String filename;

  UploadDocumentRequest({
    required this.file,
    required this.type,
    required this.filename,
  });
}
