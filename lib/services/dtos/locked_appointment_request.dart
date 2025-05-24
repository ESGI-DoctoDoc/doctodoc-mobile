class LockedAppointmentRequest {
  final String doctorId;
  final String patientId;
  final String medicalConcernId;
  final String slotId;
  final String date;
  final String time;

  LockedAppointmentRequest({
    required this.doctorId,
    required this.patientId,
    required this.medicalConcernId,
    required this.slotId,
    required this.date,
    required this.time,
  });
}
