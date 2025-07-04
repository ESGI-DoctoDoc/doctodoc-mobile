import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/services/repositories/care_tracking_repository/care_tracking_repository.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';
import '../../../models/document.dart';

part 'display_document_detail_event.dart';
part 'display_document_detail_state.dart';

class DisplayDocumentDetailBloc
    extends Bloc<DisplayDocumentDetailEvent, DisplayDocumentDetailState> {
  final MedicalRecordRepository medicalRecordRepository;
  final CareTrackingRepository careTrackingRepository;

  DisplayDocumentDetailBloc({
    required this.medicalRecordRepository,
    required this.careTrackingRepository,
  }) : super(DocumentDetailInitial()) {
    on<OnGetDocumentDetailInMedicalRecord>(_onGetDocumentDetailInMedicalRecord);
    on<OnGetDocumentDetailInCareTracking>(_onGetDocumentDetailInCareTracking);
  }

  Future<void> _onGetDocumentDetailInMedicalRecord(
      OnGetDocumentDetailInMedicalRecord event, Emitter<DisplayDocumentDetailState> emit) async {
    try {
      emit(DocumentDetailLoading());
      DocumentDetailed document = await medicalRecordRepository.getDetailDocumentById(event.id);
      emit(DocumentDetailLoaded(document: document));
    } catch (error) {
      emit(DocumentDetailError(
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetDocumentDetailInCareTracking(
      OnGetDocumentDetailInCareTracking event, Emitter<DisplayDocumentDetailState> emit) async {
    try {
      emit(DocumentDetailLoading());
      DocumentDetailed document =
          await careTrackingRepository.getDetailDocumentById(event.careTrackingId, event.id);
      emit(DocumentDetailLoaded(document: document));
    } catch (error) {
      emit(DocumentDetailError(
        exception: AppException.from(error),
      ));
    }
  }
}
