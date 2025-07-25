import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/services/dtos/locked_appointment_request.dart';
import 'package:doctodoc_mobile/services/dtos/pre_appointment_answers.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_repository/appointment_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository appointmentRepository;

  AppointmentBloc({required this.appointmentRepository}) : super(AppointmentInitial()) {
    on<OnLockedAppointment>(_onLockedAppointment);
    on<OnConfirmAppointment>(_onConfirmAppointment);
    on<OnUnlockedAppointment>(_onUnlockedAppointment);
    on<OnCancelAppointment>(_onCancelAppointment);
  }

  Future<void> _onLockedAppointment(
      OnLockedAppointment event, Emitter<AppointmentState> emit) async {
    try {
      LockedAppointmentRequest request = LockedAppointmentRequest(
        doctorId: event.doctorId,
        patientId: event.patientId,
        medicalConcernId: event.medicalConcernId,
        slotId: event.slotId,
        careTrackingId: event.careTrackingId,
        date: event.date,
        time: event.time,
        answers: event.answers,
      );

      String appointmentLockedId = await appointmentRepository.lockedAppointment(request);

      emit(AppointmentLocked(
        status: AppointmentLockedStatus.success,
        appointmentLockedId: appointmentLockedId,
      ));
    } catch (error) {
      emit(AppointmentLocked(
        status: AppointmentLockedStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onConfirmAppointment(
      OnConfirmAppointment event, Emitter<AppointmentState> emit) async {
    if (state is! AppointmentLocked) return;

    final currentState = state as AppointmentLocked;

    try {
      String? appointmentLockedId = currentState.appointmentLockedId;
      if (appointmentLockedId != null) {
        await appointmentRepository.confirm(appointmentLockedId);
        emit(AppointmentConfirm(status: AppointmentConfirmStatus.success));
      }
    } catch (error) {
      emit(AppointmentLocked(
        status: AppointmentLockedStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onUnlockedAppointment(
      OnUnlockedAppointment event, Emitter<AppointmentState> emit) async {
    if (state is! AppointmentLocked) return;

    final currentState = state as AppointmentLocked;

    try {
      String? appointmentLockedId = currentState.appointmentLockedId;
      if (appointmentLockedId != null) {
        await appointmentRepository.unlocked(appointmentLockedId);
        emit(AppointmentInitial());
      }
    } catch (error) {
      emit(AppointmentLocked(
        status: AppointmentLockedStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onCancelAppointment(
      OnCancelAppointment event, Emitter<AppointmentState> emit) async {
    try {
      emit(AppointmentCancel(status: AppointmentCancelStatus.loading));
      appointmentRepository.cancel(event.id, event.reason);
      emit(AppointmentCancel(status: AppointmentCancelStatus.success));
    } catch (error) {
      emit(AppointmentCancel(
        status: AppointmentCancelStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
