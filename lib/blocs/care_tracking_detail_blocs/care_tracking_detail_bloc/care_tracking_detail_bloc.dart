import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/care_tracking.dart';
import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/repositories/care_tracking_repository/care_tracking_repository.dart';
import 'package:doctodoc_mobile/services/repositories/care_tracking_repository/care_tracking_repository_event.dart';
import 'package:meta/meta.dart';

part 'care_tracking_detail_event.dart';
part 'care_tracking_detail_state.dart';

class CareTrackingDetailBloc extends Bloc<CareTrackingDetailEvent, CareTrackingDetailState> {
  final CareTrackingRepository careTrackingRepository;

  late StreamSubscription _careTrackingRepositoryEventSubscription;

  CareTrackingDetailBloc({
    required this.careTrackingRepository,
  }) : super(CareTrackingDetailInitial()) {
    on<OnGetCareTrackingDetail>(_onGetCareTrackingDetail);
    on<OnGetUpdatedDocuments>(_onGetUpdatedDocuments);
    on<OnDeleteDocument>(_onDeleteDocument);
    on<OnUpdateDocument>(_onUpdateDocument);

    _careTrackingRepositoryEventSubscription =
        careTrackingRepository.careTrackingRepositoryEventStream.listen((event) {
      if (event is UploadCareTrackingDocumentEvent) {
        add(OnGetUpdatedDocuments(careTrackingId: event.id));
      }

      if (event is DeleteCareTrackingDocumentEvent) {
        add(OnDeleteDocument(id: event.id));
      }

      if (event is UpdateCareTrackingDocumentEvent) {
        add(OnUpdateDocument(
          id: event.id,
          type: event.type,
          filename: event.filename,
        ));
      }
    });
  }

  Future<void> _onGetCareTrackingDetail(
      OnGetCareTrackingDetail event, Emitter<CareTrackingDetailState> emit) async {
    try {
      emit(CareTrackingDetailLoading());
      CareTrackingDetailed careTrackingDetailed = await careTrackingRepository.getById(event.id);
      emit(CareTrackingDetailLoaded(careTracking: careTrackingDetailed));
    } catch (error) {
      emit(CareTrackingDetailError(exception: AppException.from(error)));
    }
  }

  Future<void> _onGetUpdatedDocuments(
      OnGetUpdatedDocuments event, Emitter<CareTrackingDetailState> emit) async {
    try {
      if (state is! CareTrackingDetailLoaded) return;

      final currentState = state as CareTrackingDetailLoaded;

      emit(CareTrackingDetailLoading());
      List<Document> documents =
          await careTrackingRepository.getDocumentsById(event.careTrackingId);

      currentState.careTracking.documents = documents;
      emit(CareTrackingDetailLoaded(careTracking: currentState.careTracking));
    } catch (error) {
      emit(CareTrackingDetailError(exception: AppException.from(error)));
    }
  }

  Future<void> _onDeleteDocument(
      OnDeleteDocument event, Emitter<CareTrackingDetailState> emit) async {
    try {
      if (state is! CareTrackingDetailLoaded) return;

      final currentState = state as CareTrackingDetailLoaded;

      emit(CareTrackingDetailLoading());

      final documents = currentState.careTracking.documents;
      documents.removeWhere((document) => document.id == event.id);

      emit(CareTrackingDetailLoaded(careTracking: currentState.careTracking));
    } catch (error) {
      emit(CareTrackingDetailError(exception: AppException.from(error)));
    }
  }

  Future<void> _onUpdateDocument(
      OnUpdateDocument event, Emitter<CareTrackingDetailState> emit) async {
    if (state is! CareTrackingDetailLoaded) return;

    final currentState = state as CareTrackingDetailLoaded;

    emit(CareTrackingDetailLoading());

    final documents = currentState.careTracking.documents;

    final documentToUpdateIndex = documents.indexWhere((document) => document.id == event.id);
    final oldDocument = documents[documentToUpdateIndex];

    final documentUpdated = Document(
      id: event.id,
      name: event.filename,
      url: oldDocument.url,
      type: event.type,
    );

    documents[documentToUpdateIndex] = documentUpdated;

    emit(CareTrackingDetailLoaded(careTracking: currentState.careTracking));
  }

  @override
  Future<void> close() {
    _careTrackingRepositoryEventSubscription.cancel();
    return super.close();
  }
}
