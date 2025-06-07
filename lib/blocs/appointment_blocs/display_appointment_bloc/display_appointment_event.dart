part of 'display_appointment_bloc.dart';

@immutable
sealed class DisplayAppointmentEvent {}

class OnGetInitialUpComing extends DisplayAppointmentEvent {}

class OnGetNextUpComing extends DisplayAppointmentEvent {}

class OnGetInitialPast extends DisplayAppointmentEvent {}

class OnGetNextPart extends DisplayAppointmentEvent {}
