import 'dart:async';

import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/appointment/appointment.dart';
import 'package:doctodoc_mobile/models/appointment/appointment_detailed.dart';
import 'package:doctodoc_mobile/services/data_sources/appointment_data_source/appointment_data_source.dart';
import 'package:doctodoc_mobile/services/dtos/locked_appointment_request.dart';

class AppointmentRepository {
  final AppointmentDataSource appointmentDataSource;

  AppointmentRepository({
    required this.appointmentDataSource,
  });

  Future<String> lockedAppointment(LockedAppointmentRequest request) async {
    try {
      return await appointmentDataSource.lockedAppointment(request);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> unlocked(String appointmentLockedId) async {
    try {
      return await appointmentDataSource.unlockedAppointment(appointmentLockedId);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> confirm(String appointmentLockedId) async {
    try {
      await appointmentDataSource.confirm(appointmentLockedId);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<List<Appointment>> getUpComing(int page) async {
    try {
      return await appointmentDataSource.getUpComingAppointments(page);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<List<Appointment>> getPastAppointments(int page) async {
    try {
      return await appointmentDataSource.getPastAppointments(page);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<AppointmentDetailed> getById(String id) async {
    try {
      return await appointmentDataSource.getById(id);
    } catch (error) {
      throw UnknownException();
    }
  }
}
