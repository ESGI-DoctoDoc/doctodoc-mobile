part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentEvent {}

class OnLockedAppointment extends AppointmentEvent {
  final String doctorId;
  final String patientId;
  final String medicalConcernId;
  final String slotId;
  final String? careTrackingId;
  final String date;
  final String time;
  final List<PreAppointmentAnswers> answers;

  OnLockedAppointment({
    required this.doctorId,
    required this.patientId,
    required this.medicalConcernId,
    required this.slotId,
    required this.careTrackingId,
    required this.date,
    required this.time,
    required this.answers,
  });
}

class OnUnlockedAppointment extends AppointmentEvent {}

class OnConfirmAppointment extends AppointmentEvent {}

class OnCancelAppointment extends AppointmentEvent {
  final String id;
  final String reason;

  OnCancelAppointment({
    required this.id,
    required this.reason,
  });
}
