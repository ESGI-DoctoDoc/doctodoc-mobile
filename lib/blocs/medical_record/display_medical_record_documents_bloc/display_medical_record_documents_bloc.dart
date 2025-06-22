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
    on<OnDeleteMedicalRecordDocument>(_onDeleteMedicalRecordDocument);
    on<OnUpdateMedicalRecordDocument>(_onUpdateMedicalRecordDocument);

    _medicalRecordRepositoryEventSubscription =
        medicalRecordRepository.medicalRecordRepositoryEventStream.listen((event) {
      if (event is UploadMedicalRecordDocumentEvent) {
        add(OnGetMedicalRecordDocuments());
      }

      if (event is DeleteMedicalRecordDocumentEvent) {
        add(OnDeleteMedicalRecordDocument(id: event.id));
      }

      if (event is UpdateMedicalRecordDocumentEvent) {
        add(OnUpdateMedicalRecordDocument(
          id: event.id,
          filename: event.filename,
          type: event.type,
        ));
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

  Future<void> _onDeleteMedicalRecordDocument(
      OnDeleteMedicalRecordDocument event, Emitter<DisplayMedicalRecordDocumentsState> emit) async {
    emit(state.copyWith(status: DisplayMedicalRecordDocumentsStatus.loading));

    final documents = state.documents;
    documents.removeWhere((document) => document.id == event.id);

    emit(state.copyWith(documents: documents, status: DisplayMedicalRecordDocumentsStatus.success));
  }

  Future<void> _onUpdateMedicalRecordDocument(
      OnUpdateMedicalRecordDocument event, Emitter<DisplayMedicalRecordDocumentsState> emit) async {
    emit(state.copyWith(status: DisplayMedicalRecordDocumentsStatus.loading));

    final documents = state.documents;

    final documentToUpdateIndex = documents.indexWhere((document) => document.id == event.id);
    final oldDocument = documents[documentToUpdateIndex];

    final documentUpdated = Document(id: event.id, name: event.filename, url: oldDocument.url);

    documents[documentToUpdateIndex] = documentUpdated;

    emit(state.copyWith(documents: documents, status: DisplayMedicalRecordDocumentsStatus.success));
  }

  @override
  Future<void> close() {
    _medicalRecordRepositoryEventSubscription.cancel();
    return super.close();
  }
}
