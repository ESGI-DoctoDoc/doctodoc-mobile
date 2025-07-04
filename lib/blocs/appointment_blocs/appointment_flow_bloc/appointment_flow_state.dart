part of 'appointment_flow_bloc.dart';

enum GetMedicalConcernsStatus { initial, loading, success, error }

enum GetQuestionStatus { initial, loading, success, error }

enum GetAppointmentAvailabilityStatus { initial, loading, success, error }

enum GetCareTrackingsStatus { initial, loading, success, error }

class AppointmentFlowState {
  final GetMedicalConcernsStatus getMedicalConcernsStatus;
  final GetQuestionStatus getQuestionStatus;
  final GetAppointmentAvailabilityStatus getAppointmentAvailabilityStatus;
  final GetCareTrackingsStatus getCareTrackingsStatus;
  final List<MedicalConcern> medicalConcerns;
  final List<MedicalConcernQuestion> questions;
  final List<MedicalConcernAppointmentAvailability> appointmentAvailability;
  final List<CareTrackingForAppointment> careTrackings;
  final AppException? exception;

  AppointmentFlowState({
    this.getMedicalConcernsStatus = GetMedicalConcernsStatus.initial,
    this.getQuestionStatus = GetQuestionStatus.initial,
    this.getAppointmentAvailabilityStatus = GetAppointmentAvailabilityStatus.initial,
    this.getCareTrackingsStatus = GetCareTrackingsStatus.initial,
    this.medicalConcerns = const [],
    this.questions = const [],
    this.appointmentAvailability = const [],
    this.careTrackings = const [],
    this.exception,
  });

  AppointmentFlowState copyWith({
    GetMedicalConcernsStatus? getMedicalConcernsStatus,
    GetQuestionStatus? getQuestionStatus,
    GetAppointmentAvailabilityStatus? getAppointmentAvailabilityStatus,
    GetCareTrackingsStatus? getCareTrackingsStatus,
    List<MedicalConcern>? medicalConcerns,
    List<MedicalConcernQuestion>? questions,
    List<CareTrackingForAppointment>? careTrackings,
    List<MedicalConcernAppointmentAvailability>? appointmentAvailability,
    AppException? exception,
  }) {
    return AppointmentFlowState(
      getMedicalConcernsStatus: getMedicalConcernsStatus ?? this.getMedicalConcernsStatus,
      getQuestionStatus: getQuestionStatus ?? this.getQuestionStatus,
      getAppointmentAvailabilityStatus:
          getAppointmentAvailabilityStatus ?? this.getAppointmentAvailabilityStatus,
      getCareTrackingsStatus: getCareTrackingsStatus ?? this.getCareTrackingsStatus,
      medicalConcerns: medicalConcerns ?? this.medicalConcerns,
      appointmentAvailability: appointmentAvailability ?? this.appointmentAvailability,
      questions: questions ?? this.questions,
      careTrackings: careTrackings ?? this.careTrackings,
      exception: exception ?? this.exception,
    );
  }
}
