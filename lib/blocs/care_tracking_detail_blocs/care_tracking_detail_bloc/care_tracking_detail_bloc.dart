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

    _careTrackingRepositoryEventSubscription =
        careTrackingRepository.careTrackingRepositoryEventStream.listen((event) {
      if (event is UploadCareTrackingDocumentEvent) {
        add(OnGetUpdatedDocuments(careTrackingId: event.id));
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

  @override
  Future<void> close() {
    _careTrackingRepositoryEventSubscription.cancel();
    return super.close();
  }
}
