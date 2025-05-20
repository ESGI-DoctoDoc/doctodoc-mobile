import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern_appointment_availability.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern_questions.dart';

import 'appointment_flow_data_source.dart';

class RemoteAppointmentFlowDataSource implements AppointmentFlowDataSource {
  final Dio dio;

  RemoteAppointmentFlowDataSource({required this.dio});

  @override
  Future<List<MedicalConcern>> getMedicalConcernsByDoctorId(String doctorId) async {
    final response = await dio.get("/patients/doctors/$doctorId/medical-concerns");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => MedicalConcern.fromJson(jsonElement)).toList();
  }

  @override
  Future<List<MedicalConcernQuestion>> getQuestionsByMedicalConcernId(
      String medicalConcernId) async {
    final response =
        await dio.get("/patients/doctors/medical-concerns/$medicalConcernId/questions");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => MedicalConcernQuestion.fromJson(jsonElement)).toList();
  }

  @override
  Future<List<MedicalConcernAppointmentAvailability>>
      getAppointmentsAvailabilityByMedicalConcernIdAndDate(
          String medicalConcernId, String date) async {
    final response = await dio.get(
        "/patients/doctors/medical-concerns/$medicalConcernId/get-appointments-availability?date=$date");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList
        .map((jsonElement) => MedicalConcernAppointmentAvailability.fromJson(jsonElement))
        .toList();
  }
}
