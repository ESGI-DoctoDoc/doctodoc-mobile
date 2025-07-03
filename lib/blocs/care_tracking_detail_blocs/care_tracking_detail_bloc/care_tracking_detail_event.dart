part of 'care_tracking_detail_bloc.dart';

@immutable
sealed class CareTrackingDetailEvent {}

class OnGetCareTrackingDetail extends CareTrackingDetailEvent {
  final String id;

  OnGetCareTrackingDetail({
    required this.id,
  });
}

class OnGetUpdatedDocuments extends CareTrackingDetailEvent {
  final String careTrackingId;

  OnGetUpdatedDocuments({
    required this.careTrackingId,
  });
}
