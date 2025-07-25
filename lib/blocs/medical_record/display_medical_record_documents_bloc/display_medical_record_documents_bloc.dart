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
    on<OnGetInitialMedicalRecordDocuments>(_onGetInitialMedicalRecordDocuments);
    on<OnGetNextMedicalRecordDocuments>(_onGetNextMedicalRecordDocuments);
    on<OnDeleteMedicalRecordDocument>(_onDeleteMedicalRecordDocument);
    on<OnUpdateMedicalRecordDocument>(_onUpdateMedicalRecordDocument);

    _medicalRecordRepositoryEventSubscription =
        medicalRecordRepository.medicalRecordRepositoryEventStream.listen((event) {
      if (event is UploadMedicalRecordDocumentEvent) {
        add(OnGetInitialMedicalRecordDocuments());
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

  Future<void> _onGetInitialMedicalRecordDocuments(OnGetInitialMedicalRecordDocuments event,
      Emitter<DisplayMedicalRecordDocumentsState> emit) async {
    try {
      emit(state.copyWith(status: DisplayMedicalRecordDocumentsStatus.initialLoading));

      int page = 0;

      List<Document> documents = await medicalRecordRepository.getDocuments(
        page: page,
        type: event.type,
      );

      bool isLoadingMore = documents.isEmpty || documents.length < 10 ? false : true;

      emit(state.copyWith(
        status: DisplayMedicalRecordDocumentsStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        documents: documents,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayMedicalRecordDocumentsStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetNextMedicalRecordDocuments(OnGetNextMedicalRecordDocuments event,
      Emitter<DisplayMedicalRecordDocumentsState> emit) async {
    try {
      if (state.status == DisplayMedicalRecordDocumentsStatus.success) {
        emit(state.copyWith(status: DisplayMedicalRecordDocumentsStatus.loading));
      } else if ((state.status == DisplayMedicalRecordDocumentsStatus.initial)) {
        emit(state.copyWith(status: DisplayMedicalRecordDocumentsStatus.initialLoading));
      } else if ((state.status == DisplayMedicalRecordDocumentsStatus.loading) ||
          (state.status == DisplayMedicalRecordDocumentsStatus.initialLoading)) {
        return;
      }

      int page = state.page + 1;

      List<Document> oldDocuments = List<Document>.from(state.documents);
      List<Document> documents = await medicalRecordRepository.getDocuments(
        page: page,
        type: event.type,
      );

      oldDocuments.addAll(documents);
      bool isLoadingMore = documents.isEmpty ? false : true;

      emit(state.copyWith(
        status: DisplayMedicalRecordDocumentsStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        documents: oldDocuments,
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

    final documentUpdated = Document(
      id: event.id,
      name: event.filename,
      url: oldDocument.url,
      type: event.type,
    );

    documents[documentToUpdateIndex] = documentUpdated;

    emit(state.copyWith(documents: documents, status: DisplayMedicalRecordDocumentsStatus.success));
  }

  @override
  Future<void> close() {
    _medicalRecordRepositoryEventSubscription.cancel();
    return super.close();
  }
}
