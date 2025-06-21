import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';

part 'display_document_content_event.dart';
part 'display_document_content_state.dart';

class DisplayDocumentContentBloc
    extends Bloc<DisplayDocumentContentEvent, DisplayDocumentContentState> {
  final MedicalRecordRepository medicalRecordRepository;

  DisplayDocumentContentBloc({
    required this.medicalRecordRepository,
  }) : super(DisplayDocumentContentState()) {
    on<OnGetContent>((event, emit) async {
      try {
        emit(state.copyWith(status: DisplayDocumentContentStatus.loading));

        Document document = await medicalRecordRepository.getDocumentById(event.id);

        emit(state.copyWith(
          status: DisplayDocumentContentStatus.success,
          document: document,
        ));
      } catch (error) {
        emit(state.copyWith(
          status: DisplayDocumentContentStatus.error,
          exception: AppException.from(error),
        ));
      }
    });
  }
}
