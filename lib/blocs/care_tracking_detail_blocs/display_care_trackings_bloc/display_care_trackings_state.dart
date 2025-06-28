part of 'display_care_trackings_bloc.dart';

enum DisplayCareTrackingsStatus { initial, initialLoading, loading, success, error }

class DisplayCareTrackingsState {
  final DisplayCareTrackingsStatus status;
  final int page;
  final bool isLoadingMore;
  final List<CareTracking> careTrackings;
  final AppException? exception;

  DisplayCareTrackingsState({
    this.status = DisplayCareTrackingsStatus.initial,
    this.page = -1,
    this.isLoadingMore = true,
    this.careTrackings = const [],
    this.exception,
  });

  DisplayCareTrackingsState copyWith({
    DisplayCareTrackingsStatus? status,
    int? page,
    List<CareTracking>? careTrackings,
    bool? isLoadingMore,
    AppException? exception,
  }) {
    return DisplayCareTrackingsState(
      status: status ?? this.status,
      page: page ?? this.page,
      careTrackings: careTrackings ?? this.careTrackings,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      exception: exception ?? this.exception,
    );
  }
}
