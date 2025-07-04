import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/dtos/upload_document_request.dart';
import 'package:doctodoc_mobile/services/repositories/care_tracking_repository/care_tracking_repository.dart';
import 'package:meta/meta.dart';

import '../../../../exceptions/app_exception.dart';
import '../../../services/dtos/update_document_request.dart';

part 'write_document_in_care_tracking_event.dart';
part 'write_document_in_care_tracking_state.dart';

class WriteDocumentInCareTrackingBloc
    extends Bloc<WriteDocumentInCareTrackingEvent, WriteDocumentInCareTrackingState> {
  final CareTrackingRepository careTrackingRepository;

  WriteDocumentInCareTrackingBloc({
    required this.careTrackingRepository,
  }) : super(const WriteDocumentInCareTrackingState()) {
    on<OnUploadDocument>(_onUploadUrl);
    on<OnDeleteDocument>(_onDeleteDocument);
    on<OnUpdateDocument>(_onUpdateDocument);
    on<OnShareDocument>(_onShareDocument);
  }

  Future<void> _onUploadUrl(
      OnUploadDocument event, Emitter<WriteDocumentInCareTrackingState> emit) async {
    emit(state.copyWith(uploadStatus: UploadDocumentStatus.loading));

    try {
      final request = UploadDocumentRequest(
        file: event.file,
        type: event.type,
        filename: event.filename,
      );

      await careTrackingRepository.uploadDocument(event.id, request);
      emit(state.copyWith(uploadStatus: UploadDocumentStatus.success));
    } catch (e) {
      emit(state.copyWith(
        uploadStatus: UploadDocumentStatus.error,
        exception: AppException.from(e),
      ));
    }
  }

  Future<void> _onDeleteDocument(
      OnDeleteDocument event, Emitter<WriteDocumentInCareTrackingState> emit) async {
    emit(state.copyWith(deleteStatus: DeleteDocumentStatus.loading));

    try {
      await careTrackingRepository.deleteDocument(event.careTrackingId, event.id);
      emit(state.copyWith(deleteStatus: DeleteDocumentStatus.success));
    } catch (e) {
      emit(state.copyWith(
        deleteStatus: DeleteDocumentStatus.error,
        exception: AppException.from(e),
      ));
    }
  }

  Future<void> _onUpdateDocument(
      OnUpdateDocument event, Emitter<WriteDocumentInCareTrackingState> emit) async {
    emit(state.copyWith(updateStatus: UpdateDocumentStatus.loading));

    try {
      final request = UpdateDocumentRequest(
        id: event.id,
        type: event.type,
        filename: event.filename,
      );

      await careTrackingRepository.updateDocument(event.careTrackingId, request);

      emit(state.copyWith(updateStatus: UpdateDocumentStatus.success));
    } catch (e) {
      emit(state.copyWith(
        updateStatus: UpdateDocumentStatus.error,
        exception: AppException.from(e),
      ));
    }
  }

  Future<void> _onShareDocument(
      OnShareDocument event, Emitter<WriteDocumentInCareTrackingState> emit) async {
    emit(state.copyWith(shareStatus: ShareDocumentStatus.loading));
    try {
      await careTrackingRepository.shareDocument(
        event.careTrackingId,
        event.document,
      );

      emit(state.copyWith(shareStatus: ShareDocumentStatus.success));
    } catch (e) {
      emit(state.copyWith(
        shareStatus: ShareDocumentStatus.error,
        exception: AppException.from(e),
      ));
    }
  }
}
