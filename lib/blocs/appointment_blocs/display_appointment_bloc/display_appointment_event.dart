part of 'display_appointment_bloc.dart';

@immutable
sealed class DisplayAppointmentEvent {}

class OnGetAllUpComing extends DisplayAppointmentEvent {}
