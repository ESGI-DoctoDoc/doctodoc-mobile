import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/services/dtos/locked_appointment_request.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_repository/appointment_repository.dart';
import 'package:meta/meta.dart';

import '../../exceptions/app_exception.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository appointmentRepository;

  AppointmentBloc({required this.appointmentRepository}) : super(AppointmentInitial()) {
    on<OnLockedAppointment>(_onLockedAppointment);
    on<OnConfirmAppointment>(_onConfirmAppointment);
    on<OnUnlockedAppointment>(_onUnlockedAppointment);
  }

  Future<void> _onLockedAppointment(
      OnLockedAppointment event, Emitter<AppointmentState> emit) async {
    try {
      LockedAppointmentRequest request = LockedAppointmentRequest(
        doctorId: event.doctorId,
        patientId: event.patientId,
        medicalConcernId: event.medicalConcernId,
        slotId: event.slotId,
        date: event.date,
        time: event.time,
      );

      String appointmentLockedId = await appointmentRepository.lockedAppointment(request);
      print(appointmentLockedId);
      emit(AppointmentLocked(
          status: AppointmentLockedStatus.success, appointmentLockedId: appointmentLockedId));
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
}
