import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository_event.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';

part 'display_medical_record_documents_event.dart';
part 'display_medical_record_documents_state.dart';

class DisplayMedicalRecordDocumentsBloc
    extends Bloc<DisplayMedicalRecordDocumentsEvent, DisplayMedicalRecordDocumentsState> {
  final MedicalRecordRepository medicalRecordRepository;

  late StreamSubscription _medicalRecordRepositoryEventSubscription;

  DisplayMedicalRecordDocumentsBloc({
    required this.medicalRecordRepository,
  }) : super(DisplayMedicalRecordDocumentsState()) {
    on<OnGetMedicalRecordDocuments>(_onGetMedicalRecordDocuments);

    _medicalRecordRepositoryEventSubscription =
        medicalRecordRepository.medicalRecordRepositoryEventStream.listen((event) {
      if (event is UploadMedicalRecordDocumentEvent) {
        add(OnGetMedicalRecordDocuments());
      }
    });
  }

  // todo pagination
  Future<void> _onGetMedicalRecordDocuments(
      OnGetMedicalRecordDocuments event, Emitter<DisplayMedicalRecordDocumentsState> emit) async {
    try {
      emit(state.copyWith(status: DisplayMedicalRecordDocumentsStatus.loading));

      List<Document> documents = await medicalRecordRepository.getAll();

      emit(state.copyWith(
        status: DisplayMedicalRecordDocumentsStatus.success,
        documents: documents,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayMedicalRecordDocumentsStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  @override
  Future<void> close() {
    _medicalRecordRepositoryEventSubscription.cancel();
    return super.close();
  }
}
