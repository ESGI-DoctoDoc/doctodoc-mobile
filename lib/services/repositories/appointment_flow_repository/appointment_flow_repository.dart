import 'dart:async';

import 'package:doctodoc_mobile/models/appointment/medical_concern.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern_appointment_availability.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern_questions.dart';
import 'package:doctodoc_mobile/services/data_sources/local_auth_data_source/local_auth_data_source.dart';

import '../../../exceptions/app_exception.dart';
import '../../../exceptions/appointment_flow_exception.dart';
import '../../../models/appointment/care_tracking_for_appointment.dart';
import '../../data_sources/appointment_flow_data_source/appointment_flow_data_source.dart';

class AppointmentFlowRepository {
  final AppointmentFlowDataSource appointmentFlowDataSource;
  final LocalAuthDataSource localAuthDataSource;

  AppointmentFlowRepository({
    required this.appointmentFlowDataSource,
    required this.localAuthDataSource,
  });

  Future<List<MedicalConcern>> getMedicalConcernsByDoctorId(String doctorId) async {
    try {
      return await appointmentFlowDataSource.getMedicalConcernsByDoctorId(doctorId);
    } catch (error) {
      throw AppointmentFlowException.from(error);
    }
  }

  Future<List<MedicalConcernQuestion>> getQuestionsByMedicalConcernId(
      String medicalConcernId) async {
    try {
      return await appointmentFlowDataSource.getQuestionsByMedicalConcernId(medicalConcernId);
    } catch (error) {
      throw AppointmentFlowException.from(error);
    }
  }

  Future<MedicalConcernAppointmentAvailability>
      getAppointmentsAvailabilityByMedicalConcernIdAndDate(
          String medicalConcernId, String date) async {
    try {
      return await appointmentFlowDataSource.getAppointmentsAvailabilityByMedicalConcernIdAndDate(
          medicalConcernId, date);
    } catch (error) {
      throw AppointmentFlowException.from(error);
    }
  }

  Future<List<CareTrackingForAppointment>> getCareTrackings(String patientId) async {
    try {
      String? userPatientId = await localAuthDataSource.retrieveUserPatientId();

      if (userPatientId == null) throw UnknownException();
      if (patientId != userPatientId) {
        return const [];
      }
      return await appointmentFlowDataSource.getCareTrackings();
    } catch (error) {
      throw AppointmentFlowException.from(error);
    }
  }
}
