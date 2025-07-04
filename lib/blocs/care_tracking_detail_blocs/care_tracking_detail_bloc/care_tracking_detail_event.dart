part of 'care_tracking_detail_bloc.dart';

@immutable
sealed class CareTrackingDetailEvent {}

class OnGetCareTrackingDetail extends CareTrackingDetailEvent {
  final String id;

  OnGetCareTrackingDetail({
    required this.id,
  });
}

class OnGetDocuments extends CareTrackingDetailEvent {
  final String careTrackingId;

  OnGetDocuments({
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
  final bool isShared;

  OnUpdateDocument({
    required this.id,
    required this.type,
    required this.filename,
    required this.isShared,
  });
}
