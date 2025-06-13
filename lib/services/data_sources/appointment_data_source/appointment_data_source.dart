import 'package:doctodoc_mobile/models/appointment/appointment_detailed.dart';
import 'package:doctodoc_mobile/services/dtos/locked_appointment_request.dart';

import '../../../models/appointment/appointment.dart';

abstract class AppointmentDataSource {
  Future<String> lockedAppointment(LockedAppointmentRequest request);

  Future<void> unlockedAppointment(String appointmentLockedId);

  Future<void> confirm(String appointmentLockedId);

  Future<List<Appointment>> getUpComingAppointments(int page);

  Future<List<Appointment>> getPastAppointments(int page);

  Future<AppointmentDetailed> getById(String id);

  Future<void> cancel(String id);
}
