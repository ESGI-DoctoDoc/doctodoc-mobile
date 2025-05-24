import 'package:doctodoc_mobile/services/dtos/locked_appointment_request.dart';

abstract class AppointmentDataSource {
  Future<String> lockedAppointment(LockedAppointmentRequest request);

  Future<void> unlockedAppointment(String appointmentLockedId);

  Future<void> confirm(String appointmentLockedId);
}
