part of 'display_care_trackings_bloc.dart';

@immutable
sealed class DisplayCareTrackingsEvent {}

class OnGetInitialCareTrackings extends DisplayCareTrackingsEvent {}

class OnGetNextCareTrackings extends DisplayCareTrackingsEvent {}
