import 'package:doctodoc_mobile/services/dtos/pre_appointment_answers.dart';

class LockedAppointmentRequest {
  final String doctorId;
  final String patientId;
  final String medicalConcernId;
  final String slotId;
  final String date;
  final String time;
  final List<PreAppointmentAnswers> answers;

  LockedAppointmentRequest({
    required this.doctorId,
    required this.patientId,
    required this.medicalConcernId,
    required this.slotId,
    required this.date,
    required this.time,
    required this.answers,
  });
}
