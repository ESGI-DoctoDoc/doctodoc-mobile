part of 'appointment_flow_bloc.dart';

@immutable
sealed class AppointmentFlowEvent {}

class GetMedicalConcerns extends AppointmentFlowEvent {
  final String doctorId;

  GetMedicalConcerns({required this.doctorId});
}

class GetQuestions extends AppointmentFlowEvent {
  final String medicalConcernId;

  GetQuestions({required this.medicalConcernId});
}

class GetCareTrackings extends AppointmentFlowEvent {}

class GetAppointmentsAvailability extends AppointmentFlowEvent {
  final String medicalConcernId;
  final String date;

  GetAppointmentsAvailability({
    required this.medicalConcernId,
    required this.date,
  });
}
