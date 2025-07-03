import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/services/dtos/upload_document_request.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';
import '../../../services/dtos/update_document_request.dart';

part 'write_document_event.dart';
part 'write_document_state.dart';

class WriteDocumentBloc extends Bloc<WriteDocumentEvent, WriteDocumentState> {
  final MedicalRecordRepository medicalRecordRepository;

  WriteDocumentBloc({
    required this.medicalRecordRepository,
  }) : super(const WriteDocumentState()) {
    on<OnUploadDocument>(_onUploadUrl);
    on<OnDeleteDocument>(_onDeleteDocument);
    on<OnUpdateDocument>(_onUpdateDocument);
  }

  Future<void> _onUploadUrl(OnUploadDocument event, Emitter<WriteDocumentState> emit) async {
    emit(state.copyWith(uploadStatus: UploadDocumentStatus.loading));

    try {
      final request = UploadDocumentRequest(
        file: event.file,
        type: event.type,
        filename: event.filename,
      );

      await medicalRecordRepository.uploadDocument(request);
      emit(state.copyWith(uploadStatus: UploadDocumentStatus.success));
    } catch (e) {
      emit(state.copyWith(
        uploadStatus: UploadDocumentStatus.error,
        exception: AppException.from(e),
      ));
    }
  }

  Future<void> _onDeleteDocument(OnDeleteDocument event, Emitter<WriteDocumentState> emit) async {
    emit(state.copyWith(deleteStatus: DeleteDocumentStatus.loading));

    try {
      await medicalRecordRepository.deleteDocument(event.id);
      emit(state.copyWith(deleteStatus: DeleteDocumentStatus.success));
    } catch (e) {
      emit(state.copyWith(
        deleteStatus: DeleteDocumentStatus.error,
        exception: AppException.from(e),
      ));
    }
  }

  Future<void> _onUpdateDocument(OnUpdateDocument event, Emitter<WriteDocumentState> emit) async {
    emit(state.copyWith(updateStatus: UpdateDocumentStatus.loading));

    try {
      final request = UpdateDocumentRequest(
        id: event.id,
        type: event.type,
        filename: event.filename,
      );

      await medicalRecordRepository.updateDocument(request);

      emit(state.copyWith(updateStatus: UpdateDocumentStatus.success));
    } catch (e) {
      emit(state.copyWith(
        updateStatus: UpdateDocumentStatus.error,
        exception: AppException.from(e),
      ));
    }
  }
}
