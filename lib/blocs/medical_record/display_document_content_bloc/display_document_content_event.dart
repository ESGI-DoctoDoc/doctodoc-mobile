part of 'display_document_content_bloc.dart';

@immutable
sealed class DisplayDocumentContentEvent {}

class OnGetContent extends DisplayDocumentContentEvent {
  final String id;

  OnGetContent({
    required this.id,
  });
}
