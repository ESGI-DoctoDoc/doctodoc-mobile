import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/services/repositories/care_tracking_repository/care_tracking_repository.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';
import '../../../models/document.dart';

part 'display_document_historic_event.dart';
part 'display_document_historic_state.dart';

class DisplayDocumentHistoricBloc
    extends Bloc<DisplayDocumentHistoricEvent, DisplayDocumentHistoricState> {
  final MedicalRecordRepository medicalRecordRepository;
  final CareTrackingRepository careTrackingRepository;

  DisplayDocumentHistoricBloc({
    required this.medicalRecordRepository,
    required this.careTrackingRepository,
  }) : super(DocumentHistoricInitial()) {
    on<OnGetDocumentTracesInMedicalRecord>(_onGetDocumentTracesInMedicalRecord);
    on<OnGetDocumentTracesInCareTracking>(_onGetDocumentTracesInCareTracking);
  }

  Future<void> _onGetDocumentTracesInMedicalRecord(
      OnGetDocumentTracesInMedicalRecord event, Emitter<DisplayDocumentHistoricState> emit) async {
    try {
      emit(DocumentHistoricLoading());
      List<DocumentTrace> traces = await medicalRecordRepository.getDocumentTracesById(event.id);
      emit(DocumentHistoricLoaded(traces: traces));
    } catch (error) {
      emit(DocumentHistoricError(
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetDocumentTracesInCareTracking(
      OnGetDocumentTracesInCareTracking event, Emitter<DisplayDocumentHistoricState> emit) async {
    try {
      emit(DocumentHistoricLoading());
      List<DocumentTrace> traces = await careTrackingRepository.getDocumentTracesById(
        event.careTrackingId,
        event.id,
      );
      emit(DocumentHistoricLoaded(traces: traces));
    } catch (error) {
      emit(DocumentHistoricError(
        exception: AppException.from(error),
      ));
    }
  }
}
