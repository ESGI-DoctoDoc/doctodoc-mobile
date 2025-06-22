part of 'display_document_detail_bloc.dart';

@immutable
sealed class DisplayDocumentDetailEvent {}

class OnGetDocumentDetail extends DisplayDocumentDetailEvent {
  final String id;

  OnGetDocumentDetail({
    required this.id,
  });
}
