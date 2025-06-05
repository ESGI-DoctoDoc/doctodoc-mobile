part of 'appointment_flow_bloc.dart';

enum GetMedicalConcernsStatus { initial, loading, success, error }

enum GetQuestionStatus { initial, loading, success, error }

enum GetAppointmentAvailabilityStatus { initial, loading, success, error }

class AppointmentFlowState {
  final GetMedicalConcernsStatus getMedicalConcernsStatus;
  final GetQuestionStatus getQuestionStatus;
  final GetAppointmentAvailabilityStatus getAppointmentAvailabilityStatus;
  final List<MedicalConcern> medicalConcerns;
  final List<MedicalConcernQuestion> questions;
  final List<MedicalConcernAppointmentAvailability> appointmentAvailability;
  final AppException? exception;

  AppointmentFlowState({
    this.getMedicalConcernsStatus = GetMedicalConcernsStatus.initial,
    this.getQuestionStatus = GetQuestionStatus.initial,
    this.getAppointmentAvailabilityStatus = GetAppointmentAvailabilityStatus.initial,
    this.medicalConcerns = const [],
    this.questions = const [],
    this.appointmentAvailability = const [],
    this.exception,
  });

  AppointmentFlowState copyWith({
    GetMedicalConcernsStatus? getMedicalConcernsStatus,
    GetQuestionStatus? getQuestionStatus,
    GetAppointmentAvailabilityStatus? getAppointmentAvailabilityStatus,
    List<MedicalConcern>? medicalConcerns,
    List<MedicalConcernQuestion>? questions,
    List<MedicalConcernAppointmentAvailability>? appointmentAvailability,
    AppException? exception,
  }) {
    return AppointmentFlowState(
      getMedicalConcernsStatus: getMedicalConcernsStatus ?? this.getMedicalConcernsStatus,
      getQuestionStatus: getQuestionStatus ?? this.getQuestionStatus,
      getAppointmentAvailabilityStatus:
          getAppointmentAvailabilityStatus ?? this.getAppointmentAvailabilityStatus,
      medicalConcerns: medicalConcerns ?? this.medicalConcerns,
      appointmentAvailability: appointmentAvailability ?? this.appointmentAvailability,
      questions: questions ?? this.questions,
      exception: exception ?? this.exception,
    );
  }
}
