part of 'most_recent_upcoming_appointment_bloc.dart';

enum MostRecentUpcomingAppointmentStatus { initial, loading, success, error }

class MostRecentUpcomingAppointmentState {
  final MostRecentUpcomingAppointmentStatus status;
  final Appointment? appointment;
  final AppException? exception;

  MostRecentUpcomingAppointmentState({
    this.status = MostRecentUpcomingAppointmentStatus.initial,
    this.appointment,
    this.exception,
  });

  MostRecentUpcomingAppointmentState copyWith({
    MostRecentUpcomingAppointmentStatus? status,
    Appointment? appointment,
    AppException? exception,
  }) {
    return MostRecentUpcomingAppointmentState(
      status: status ?? this.status,
      appointment: appointment,
      exception: exception ?? this.exception,
    );
  }
}
