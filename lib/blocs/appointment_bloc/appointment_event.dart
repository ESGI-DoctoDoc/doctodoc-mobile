part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentEvent {}

class OnLockedAppointment extends AppointmentEvent {
  final String doctorId;
  final String patientId;
  final String medicalConcernId;
  final String slotId;
  final String date;
  final String time;

// todo answers

  OnLockedAppointment({
    required this.doctorId,
    required this.patientId,
    required this.medicalConcernId,
    required this.slotId,
    required this.date,
    required this.time,
  });
}

class OnUnlockedAppointment extends AppointmentEvent {}

class OnConfirmAppointment extends AppointmentEvent {}
