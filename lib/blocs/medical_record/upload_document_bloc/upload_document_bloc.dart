import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/services/dtos/upload_document_request.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';

part 'upload_document_event.dart';
part 'upload_document_state.dart';

class UploadDocumentBloc extends Bloc<UploadDocumentEvent, UploadDocumentState> {
  final MedicalRecordRepository medicalRecordRepository;

  UploadDocumentBloc({
    required this.medicalRecordRepository,
  }) : super(UploadDocumentState()) {
    on<OnUploadUrl>((event, emit) async {
      try {
        emit(state.copyWith(status: UploadDocumentStatus.loading));

        UploadDocumentRequest uploadDocumentRequest = UploadDocumentRequest(
          file: event.file,
          type: event.type,
          filename: event.filename,
        );

        await medicalRecordRepository.uploadDocument(uploadDocumentRequest);
        emit(state.copyWith(status: UploadDocumentStatus.success));
      } catch (error) {
        emit(state.copyWith(
          status: UploadDocumentStatus.error,
          exception: AppException.from(error),
        ));
      }
    });
  }
}
