import 'package:doctodoc_mobile/services/dtos/locked_appointment_request.dart';

import '../../../models/appointment.dart';

abstract class AppointmentDataSource {
  Future<String> lockedAppointment(LockedAppointmentRequest request);

  Future<void> unlockedAppointment(String appointmentLockedId);

  Future<void> confirm(String appointmentLockedId);

  Future<List<Appointment>> getAllUpcoming(int page);
}
