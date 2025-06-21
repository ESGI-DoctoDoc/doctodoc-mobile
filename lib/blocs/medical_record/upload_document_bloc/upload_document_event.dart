part of 'upload_document_bloc.dart';

@immutable
sealed class UploadDocumentEvent {}

class OnUploadUrl extends UploadDocumentEvent {
  final File file;
  final String type;
  final String filename;

  OnUploadUrl({
    required this.file,
    required this.type,
    required this.filename,
  });
}
