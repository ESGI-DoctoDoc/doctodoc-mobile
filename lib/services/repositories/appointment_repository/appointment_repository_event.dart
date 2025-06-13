abstract class AppointmentRepositoryEvent {}

class CancelAppointmentEvent extends AppointmentRepositoryEvent {
  final String id;

  CancelAppointmentEvent({required this.id});
}
