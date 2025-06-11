import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/appointment/appointment_detailed.dart';
import 'package:doctodoc_mobile/services/dtos/locked_appointment_request.dart';

import '../../../models/appointment/appointment.dart';
import 'appointment_data_source.dart';

class RemoteAppointmentDataSource implements AppointmentDataSource {
  final Dio dio;

  RemoteAppointmentDataSource({required this.dio});

  @override
  Future<String> lockedAppointment(LockedAppointmentRequest request) async {
    final response = await dio.post(
      "/patients/appointments",
      data: jsonEncode({
        "doctorId": request.doctorId,
        "patientId": request.patientId,
        "medicalConcernId": request.medicalConcernId,
        "slotId": request.slotId,
        "date": request.date,
        "time": request.time,
        "responses": request.answers.map((answer) => {
          "questionId": answer.questionId,
          "answer": answer.answer,
        }).toList(),
      }),
    );

    return response.data["data"]["appointmentLockedId"];
  }

  @override
  Future<void> confirm(String appointmentLockedId) async {
    await dio.patch("/patients/appointments/$appointmentLockedId");
  }

  @override
  Future<void> unlockedAppointment(String appointmentLockedId) async {
    await dio.delete("/patients/appointments/$appointmentLockedId");
  }

  @override
  Future<List<Appointment>> getUpComingAppointments(int page) async {
    int defaultSize = 10;
    final response =
        await dio.get("/patients/appointments/get-all-upcoming?page=$page&size=$defaultSize");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => Appointment.fromJson(jsonElement)).toList();
  }

  @override
  Future<List<Appointment>> getPastAppointments(int page) async {
    int defaultSize = 10;
    final response =
        await dio.get("/patients/appointments/get-all-past?page=$page&size=$defaultSize");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => Appointment.fromJson(jsonElement)).toList();
  }

  @override
  Future<AppointmentDetailed> getById(String id) async {
    final response = await dio.get("/patients/appointments/$id");
    return AppointmentDetailed.fromJson(response.data["data"]);
  }
}
