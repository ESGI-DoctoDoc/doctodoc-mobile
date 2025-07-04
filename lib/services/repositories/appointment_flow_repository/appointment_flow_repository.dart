import 'dart:async';

import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern_appointment_availability.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern_questions.dart';

import '../../../models/appointment/care_tracking_for_appointment.dart';
import '../../data_sources/appointment_flow_data_source/appointment_flow_data_source.dart';

class AppointmentFlowRepository {
  final AppointmentFlowDataSource appointmentFlowDataSource;

  AppointmentFlowRepository({
    required this.appointmentFlowDataSource,
  });

  Future<List<MedicalConcern>> getMedicalConcernsByDoctorId(String doctorId) async {
    try {
      return await appointmentFlowDataSource.getMedicalConcernsByDoctorId(doctorId);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<List<MedicalConcernQuestion>> getQuestionsByMedicalConcernId(
      String medicalConcernId) async {
    try {
      return await appointmentFlowDataSource.getQuestionsByMedicalConcernId(medicalConcernId);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<List<MedicalConcernAppointmentAvailability>>
      getAppointmentsAvailabilityByMedicalConcernIdAndDate(
          String medicalConcernId, String date) async {
    try {
      return await appointmentFlowDataSource.getAppointmentsAvailabilityByMedicalConcernIdAndDate(
          medicalConcernId, date);
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<List<CareTrackingForAppointment>> getCareTrackings() async {
    try {
      return await appointmentFlowDataSource.getCareTrackings();
    } catch (error) {
      throw UnknownException();
    }
  }
}
