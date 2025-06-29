import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';
import '../../../models/document.dart';

part 'display_document_historic_event.dart';
part 'display_document_historic_state.dart';

class DisplayDocumentHistoricBloc
    extends Bloc<DisplayDocumentHistoricEvent, DisplayDocumentHistoricState> {
  final MedicalRecordRepository medicalRecordRepository;

  DisplayDocumentHistoricBloc({
    required this.medicalRecordRepository,
  }) : super(DocumentHistoricInitial()) {
    on<OnGetDocumentTraces>(_onGetDocumentTraces);
  }

  Future<void> _onGetDocumentTraces(
      OnGetDocumentTraces event, Emitter<DisplayDocumentHistoricState> emit) async {
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
}
