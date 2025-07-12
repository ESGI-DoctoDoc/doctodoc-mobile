import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository.dart';
import 'package:doctodoc_mobile/services/repositories/medical_record/medical_record_repository_event.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';

part 'display_medical_record_documents_type_event.dart';
part 'display_medical_record_documents_type_state.dart';

class DisplayMedicalRecordDocumentsTypeBloc
    extends Bloc<DisplayMedicalRecordDocumentsTypeEvent, DisplayMedicalRecordDocumentsTypeState> {
  final MedicalRecordRepository medicalRecordRepository;

  late StreamSubscription _medicalRecordRepositoryEventSubscription;

  DisplayMedicalRecordDocumentsTypeBloc({
    required this.medicalRecordRepository,
  }) : super(DisplayMedicalRecordDocumentsTypeState()) {
    on<OnGetInitialMedicalRecordTypeDocuments>(_onGetInitialMedicalRecordDocuments);
    on<OnGetNextMedicalRecordTypeDocuments>(_onGetNextMedicalRecordDocuments);
    on<OnDeleteMedicalRecordTypeDocument>(_onDeleteMedicalRecordDocument);
    on<OnUpdateMedicalRecordTypeDocument>(_onUpdateMedicalRecordDocument);

    _medicalRecordRepositoryEventSubscription =
        medicalRecordRepository.medicalRecordRepositoryEventStream.listen((event) {
      if (event is UploadMedicalRecordDocumentEvent) {
        add(OnGetInitialMedicalRecordTypeDocuments());
      }

      if (event is DeleteMedicalRecordDocumentEvent) {
        add(OnDeleteMedicalRecordTypeDocument(id: event.id));
      }

      if (event is UpdateMedicalRecordDocumentEvent) {
        add(OnUpdateMedicalRecordTypeDocument(
          id: event.id,
          filename: event.filename,
          type: event.type,
        ));
      }
    });
  }

  Future<void> _onGetInitialMedicalRecordDocuments(OnGetInitialMedicalRecordTypeDocuments event,
      Emitter<DisplayMedicalRecordDocumentsTypeState> emit) async {
    try {
      emit(state.copyWith(status: DisplayMedicalRecordDocumentsTypeStatus.initialLoading));

      int page = 0;

      List<Document> documents = await medicalRecordRepository.getDocuments(
        page: page,
        type: event.type,
      );

      bool isLoadingMore = documents.isEmpty || documents.length < 10 ? false : true;

      emit(state.copyWith(
        status: DisplayMedicalRecordDocumentsTypeStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        documents: documents,
        type: event.type,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayMedicalRecordDocumentsTypeStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetNextMedicalRecordDocuments(OnGetNextMedicalRecordTypeDocuments event,
      Emitter<DisplayMedicalRecordDocumentsTypeState> emit) async {
    try {
      if (state.status == DisplayMedicalRecordDocumentsTypeStatus.success) {
        emit(state.copyWith(status: DisplayMedicalRecordDocumentsTypeStatus.loading));
      } else if ((state.status == DisplayMedicalRecordDocumentsTypeStatus.initial)) {
        emit(state.copyWith(status: DisplayMedicalRecordDocumentsTypeStatus.initialLoading));
      } else if ((state.status == DisplayMedicalRecordDocumentsTypeStatus.loading) ||
          (state.status == DisplayMedicalRecordDocumentsTypeStatus.initialLoading)) {
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
        status: DisplayMedicalRecordDocumentsTypeStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        documents: oldDocuments,
        type: event.type,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayMedicalRecordDocumentsTypeStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onDeleteMedicalRecordDocument(OnDeleteMedicalRecordTypeDocument event,
      Emitter<DisplayMedicalRecordDocumentsTypeState> emit) async {
    emit(state.copyWith(status: DisplayMedicalRecordDocumentsTypeStatus.loading));

    final documents = state.documents;
    documents.removeWhere((document) => document.id == event.id);

    emit(state.copyWith(
        documents: documents, status: DisplayMedicalRecordDocumentsTypeStatus.success));
  }

  Future<void> _onUpdateMedicalRecordDocument(OnUpdateMedicalRecordTypeDocument event,
      Emitter<DisplayMedicalRecordDocumentsTypeState> emit) async {
    emit(state.copyWith(status: DisplayMedicalRecordDocumentsTypeStatus.loading));
    final documents = state.documents;

    if (state.type != event.type) {
      add(OnDeleteMedicalRecordTypeDocument(id: event.id));
    } else {
      final documentToUpdateIndex = documents.indexWhere((document) => document.id == event.id);
      final oldDocument = documents[documentToUpdateIndex];

      final documentUpdated = Document(
        id: event.id,
        name: event.filename,
        url: oldDocument.url,
        type: event.type,
      );

      documents[documentToUpdateIndex] = documentUpdated;

      emit(state.copyWith(
          documents: documents, status: DisplayMedicalRecordDocumentsTypeStatus.success));
    }
  }

  @override
  Future<void> close() {
    _medicalRecordRepositoryEventSubscription.cancel();
    return super.close();
  }
}
