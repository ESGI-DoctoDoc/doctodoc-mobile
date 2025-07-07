import 'dart:async';

import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/appointment/appointment.dart';
import 'package:doctodoc_mobile/models/appointment/appointment_detailed.dart';
import 'package:doctodoc_mobile/services/data_sources/appointment_data_source/appointment_data_source.dart';
import 'package:doctodoc_mobile/services/dtos/locked_appointment_request.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_repository/appointment_repository_event.dart';

class AppointmentRepository {
  final AppointmentDataSource appointmentDataSource;

  AppointmentRepository({
    required this.appointmentDataSource,
  });

  final _appointmentRepositoryEventController =
      StreamController<AppointmentRepositoryEvent>.broadcast();

  Stream<AppointmentRepositoryEvent> get appointmentRepositoryEventStream =>
      _appointmentRepositoryEventController.stream;

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

  Future<List<Appointment>> getUpComingAppointments(int page) async {
    try {
      return await appointmentDataSource.getUpComingAppointments(page);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<Appointment?> getMostRecentUpComingAppointment() async {
    try {
      return await appointmentDataSource.getMostRecentUpComingAppointment();
    } on DioException catch (error) {
      final code = error.response?.data["code"];
      var noneUpComingAppointmentKey = "appointment.empty";

      if (code == noneUpComingAppointmentKey) {
        return null;
      }
      throw UnknownException();
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

  Future<void> cancel(String id, String reason) async {
    try {
      await appointmentDataSource.cancel(id, reason);
      _appointmentRepositoryEventController.add(CancelAppointmentEvent(id: id));
    } catch (error) {
      throw UnknownException();
    }
  }

  dispose() {
    _appointmentRepositoryEventController.close();
  }
}
