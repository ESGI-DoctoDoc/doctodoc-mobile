import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern_appointment_availability.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern_questions.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_flow_repository/appointment_flow_repository.dart';
import 'package:meta/meta.dart';

import '../../../models/appointment/care_tracking_for_appointment.dart';

part 'appointment_flow_event.dart';
part 'appointment_flow_state.dart';

class AppointmentFlowBloc extends Bloc<AppointmentFlowEvent, AppointmentFlowState> {
  final AppointmentFlowRepository appointmentFlowRepository;

  AppointmentFlowBloc({required this.appointmentFlowRepository}) : super(AppointmentFlowState()) {
    on<GetMedicalConcerns>(_onGetMedicalConcerns);
    on<GetQuestions>(_onGetQuestions);
    on<GetAppointmentsAvailability>(_onGetAppointmentsAvailability);
    on<GetCareTrackings>(_getCareTrackings);
  }

  Future<void> _onGetMedicalConcerns(
      GetMedicalConcerns event, Emitter<AppointmentFlowState> emit) async {
    try {
      emit(state.copyWith(getMedicalConcernsStatus: GetMedicalConcernsStatus.loading));

      List<MedicalConcern> medicalConcerns =
          await appointmentFlowRepository.getMedicalConcernsByDoctorId(event.doctorId);

      emit(state.copyWith(
        getMedicalConcernsStatus: GetMedicalConcernsStatus.success,
        medicalConcerns: medicalConcerns,
      ));
    } catch (error) {
      emit(state.copyWith(
        getMedicalConcernsStatus: GetMedicalConcernsStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetQuestions(GetQuestions event, Emitter<AppointmentFlowState> emit) async {
    try {
      emit(state.copyWith(getQuestionStatus: GetQuestionStatus.loading));

      List<MedicalConcernQuestion> questions =
          await appointmentFlowRepository.getQuestionsByMedicalConcernId(event.medicalConcernId);

      emit(state.copyWith(
        getQuestionStatus: GetQuestionStatus.success,
        questions: questions,
      ));
    } catch (error) {
      emit(state.copyWith(
        getQuestionStatus: GetQuestionStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _getCareTrackings(GetCareTrackings event, Emitter<AppointmentFlowState> emit) async {
    try {
      emit(state.copyWith(getCareTrackingsStatus: GetCareTrackingsStatus.loading));

      List<CareTrackingForAppointment> careTrackings =
          await appointmentFlowRepository.getCareTrackings(event.patientId);

      emit(state.copyWith(
        getCareTrackingsStatus: GetCareTrackingsStatus.success,
        careTrackings: careTrackings,
      ));
    } catch (error) {
      emit(state.copyWith(
        getCareTrackingsStatus: GetCareTrackingsStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetAppointmentsAvailability(
      GetAppointmentsAvailability event, Emitter<AppointmentFlowState> emit) async {
    try {
      emit(state.copyWith(
          getAppointmentAvailabilityStatus: GetAppointmentAvailabilityStatus.loading));

      MedicalConcernAppointmentAvailability appointmentsAvailability =
          await appointmentFlowRepository.getAppointmentsAvailabilityByMedicalConcernIdAndDate(
        event.medicalConcernId,
        event.date,
      );

      emit(state.copyWith(
        getAppointmentAvailabilityStatus: GetAppointmentAvailabilityStatus.success,
        appointmentAvailability: appointmentsAvailability,
      ));
    } catch (error) {
      emit(state.copyWith(
        getAppointmentAvailabilityStatus: GetAppointmentAvailabilityStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
