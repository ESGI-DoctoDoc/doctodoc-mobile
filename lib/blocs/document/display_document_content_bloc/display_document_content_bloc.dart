import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/repositories/care_tracking_repository/care_tracking_repository.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';

part 'display_document_content_event.dart';
part 'display_document_content_state.dart';

class DisplayDocumentContentBloc
    extends Bloc<DisplayDocumentContentEvent, DisplayDocumentContentState> {
  final MedicalRecordRepository medicalRecordRepository;
  final CareTrackingRepository careTrackingRepository;

  DisplayDocumentContentBloc({
    required this.medicalRecordRepository,
    required this.careTrackingRepository,
  }) : super(DisplayDocumentContentState()) {
    on<OnGetContentOnMedicalRecord>(_onGetContentOnMedicalRecord);
    on<OnGetContentOnCareTracking>(_onGetContentOnCareTracking);
  }

  Future<void> _onGetContentOnMedicalRecord(
      OnGetContentOnMedicalRecord event, Emitter<DisplayDocumentContentState> emit) async {
    try {
      emit(state.copyWith(
          displayDocumentContentOfMedicalRecordStatus:
              DisplayDocumentContentOfMedicalRecordStatus.loading));

      Document document = await medicalRecordRepository.getDocumentById(event.id);

      emit(state.copyWith(
        displayDocumentContentOfMedicalRecordStatus:
            DisplayDocumentContentOfMedicalRecordStatus.success,
        document: document,
      ));
    } catch (error) {
      emit(state.copyWith(
        displayDocumentContentOfMedicalRecordStatus:
            DisplayDocumentContentOfMedicalRecordStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetContentOnCareTracking(
      OnGetContentOnCareTracking event, Emitter<DisplayDocumentContentState> emit) async {
    try {
      emit(state.copyWith(
          displayDocumentContentOfCareTrackingStatus:
              DisplayDocumentContentOfCareTrackingStatus.loading));

      Document document =
          await careTrackingRepository.getDocumentById(event.careTrackingId, event.id);

      emit(state.copyWith(
        displayDocumentContentOfCareTrackingStatus:
            DisplayDocumentContentOfCareTrackingStatus.success,
        document: document,
      ));
    } catch (error) {
      emit(state.copyWith(
        displayDocumentContentOfCareTrackingStatus:
            DisplayDocumentContentOfCareTrackingStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
