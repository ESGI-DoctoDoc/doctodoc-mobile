import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/services/dtos/locked_appointment_request.dart';

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
}
