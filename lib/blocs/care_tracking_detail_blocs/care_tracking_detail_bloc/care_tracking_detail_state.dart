part of 'care_tracking_detail_bloc.dart';

sealed class CareTrackingDetailState {}

class CareTrackingDetailInitial extends CareTrackingDetailState {}

class CareTrackingDetailLoading extends CareTrackingDetailState {}

class CareTrackingDetailError extends CareTrackingDetailState {
  final AppException exception;

  CareTrackingDetailError({
    required this.exception,
  });
}

class CareTrackingDetailLoaded extends CareTrackingDetailState {
  final CareTrackingDetailed careTracking;

  CareTrackingDetailLoaded({
    required this.careTracking,
  });

  CareTrackingDetailLoaded copyWith({
    CareTrackingDetailed? careTracking,
  }) {
    return CareTrackingDetailLoaded(
      careTracking: careTracking ?? this.careTracking,
    );
  }
}
