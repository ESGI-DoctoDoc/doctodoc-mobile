import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/models/care_tracking.dart';
import 'package:doctodoc_mobile/services/repositories/care_tracking_repository/care_tracking_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';

part 'display_care_trackings_event.dart';
part 'display_care_trackings_state.dart';

class DisplayCareTrackingsBloc extends Bloc<DisplayCareTrackingsEvent, DisplayCareTrackingsState> {
  final CareTrackingRepository careTrackingRepository;

  DisplayCareTrackingsBloc({
    required this.careTrackingRepository,
  }) : super(DisplayCareTrackingsState()) {
    on<OnGetInitialCareTrackings>(_onGetInitial);
    on<OnGetNextCareTrackings>(_onGetNextCareTrackings);
  }

  Future<void> _onGetInitial(
      OnGetInitialCareTrackings event, Emitter<DisplayCareTrackingsState> emit) async {
    try {
      emit(state.copyWith(status: DisplayCareTrackingsStatus.initialLoading));

      int page = 0;

      List<CareTracking> careTrackings = await careTrackingRepository.getAll(page);

      bool isLoadingMore = careTrackings.isEmpty || careTrackings.length < 10 ? false : true;
      emit(state.copyWith(
        status: DisplayCareTrackingsStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        careTrackings: careTrackings,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayCareTrackingsStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetNextCareTrackings(
      OnGetNextCareTrackings event, Emitter<DisplayCareTrackingsState> emit) async {
    try {
      if (state.status == DisplayCareTrackingsStatus.success) {
        emit(state.copyWith(status: DisplayCareTrackingsStatus.loading));
      } else if ((state.status == DisplayCareTrackingsStatus.initial)) {
        emit(state.copyWith(status: DisplayCareTrackingsStatus.initialLoading));
      } else if ((state.status == DisplayCareTrackingsStatus.loading) ||
          (state.status == DisplayCareTrackingsStatus.initialLoading)) {
        return;
      }

      int page = state.page + 1;

      List<CareTracking> oldCareTrackings = List<CareTracking>.from(state.careTrackings);

      List<CareTracking> appointments = await careTrackingRepository.getAll(page);

      oldCareTrackings.addAll(appointments);
      bool isLoadingMore = appointments.isEmpty ? false : true;

      emit(state.copyWith(
        status: DisplayCareTrackingsStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        careTrackings: oldCareTrackings,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayCareTrackingsStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
