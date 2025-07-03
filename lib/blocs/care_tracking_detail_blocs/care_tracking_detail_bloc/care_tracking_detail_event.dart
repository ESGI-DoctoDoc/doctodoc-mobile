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

class OnDeleteDocument extends CareTrackingDetailEvent {
  final String id;

  OnDeleteDocument({
    required this.id,
  });
}

class OnUpdateDocument extends CareTrackingDetailEvent {
  final String id;
  final String type;
  final String filename;

  OnUpdateDocument({
    required this.id,
    required this.type,
    required this.filename,
  });
}
