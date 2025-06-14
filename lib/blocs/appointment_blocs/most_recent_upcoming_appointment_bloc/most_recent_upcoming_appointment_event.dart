part of 'most_recent_upcoming_appointment_bloc.dart';

@immutable
sealed class MostRecentUpcomingAppointmentEvent {}

class OnGet extends MostRecentUpcomingAppointmentEvent {}
