part of 'display_appointments_bloc.dart';

@immutable
sealed class DisplayAppointmentsEvent {}

class OnGetInitialUpComing extends DisplayAppointmentsEvent {}

class OnGetNextUpComing extends DisplayAppointmentsEvent {}

class OnGetInitialPast extends DisplayAppointmentsEvent {}

class OnGetNextPart extends DisplayAppointmentsEvent {}

class OnDeleteAppointmentUpComings extends DisplayAppointmentsEvent {
  final String id;

  OnDeleteAppointmentUpComings({
    required this.id,
  });
}
