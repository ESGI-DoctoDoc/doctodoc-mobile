part of 'appointment_bloc.dart';

final class AppointmentState {
  final MedicalConcern? medicalConcern;
  final AppException? exception;

  AppointmentState({
    this.medicalConcern,
    this.exception,
  });
}
