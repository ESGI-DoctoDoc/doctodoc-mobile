part of 'write_document_bloc.dart';

@immutable
sealed class WriteDocumentEvent {}

class OnUploadDocument extends WriteDocumentEvent {
  final File file;
  final String type;
  final String filename;

  OnUploadDocument({
    required this.file,
    required this.type,
    required this.filename,
  });
}

class OnDeleteDocument extends WriteDocumentEvent {
  final String id;

  OnDeleteDocument({
    required this.id,
  });
}

class OnUpdateDocument extends WriteDocumentEvent {
  final String id;
  final String type;
  final String filename;

  OnUpdateDocument({
    required this.id,
    required this.type,
    required this.filename,
  });
}
