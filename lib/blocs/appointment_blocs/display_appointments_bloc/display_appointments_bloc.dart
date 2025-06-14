import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/appointment/appointment.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_repository/appointment_repository.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_repository/appointment_repository_event.dart';
import 'package:meta/meta.dart';

part 'display_appointments_event.dart';
part 'display_appointments_state.dart';

class DisplayAppointmentsBloc extends Bloc<DisplayAppointmentsEvent, DisplayAppointmentsState> {
  final AppointmentRepository appointmentRepository;

  late StreamSubscription _appointmentRepositoryEventSubscription;

  DisplayAppointmentsBloc({
    required this.appointmentRepository,
  }) : super(DisplayAppointmentsState()) {
    on<OnGetInitialUpComing>(_onGetInitial);
    on<OnGetNextUpComing>(_onGetNextUpComing);
    on<OnGetInitialPast>(_onGetInitialPast);
    on<OnGetNextPart>(_onGetNextPart);
    on<OnDeleteAppointmentUpComings>(_onDeleteAppointmentUpComings);

    _appointmentRepositoryEventSubscription =
        appointmentRepository.appointmentRepositoryEventStream.listen((event) {
      if (event is CancelAppointmentEvent) {
        add(OnDeleteAppointmentUpComings(id: event.id));
      }
    });
  }

  Future<void> _onGetInitial(OnGetInitialUpComing event,
      Emitter<DisplayAppointmentsState> emit) async {
    try {
      emit(state.copyWith(status: DisplayAppointmentsStatus.initialLoading));

      int page = 0;

      List<Appointment> appointments = await appointmentRepository.getUpComingAppointments(page);

      bool isLoadingMore = appointments.isEmpty || appointments.length < 10 ? false : true;
      emit(state.copyWith(
        status: DisplayAppointmentsStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        appointments: appointments,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayAppointmentsStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetNextUpComing(OnGetNextUpComing event,
      Emitter<DisplayAppointmentsState> emit) async {
    try {
      if (state.status == DisplayAppointmentsStatus.success) {
        emit(state.copyWith(status: DisplayAppointmentsStatus.loading));
      } else if ((state.status == DisplayAppointmentsStatus.initial)) {
        emit(state.copyWith(status: DisplayAppointmentsStatus.initialLoading));
      } else if ((state.status == DisplayAppointmentsStatus.loading) ||
          (state.status == DisplayAppointmentsStatus.initialLoading)) {
        return;
      }

      int page = state.page + 1;

      List<Appointment> oldAppointments = List<Appointment>.from(state.appointments);

      List<Appointment> appointments = await appointmentRepository.getUpComingAppointments(page);

      oldAppointments.addAll(appointments);
      bool isLoadingMore = appointments.isEmpty ? false : true;

      emit(state.copyWith(
        status: DisplayAppointmentsStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        appointments: oldAppointments,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayAppointmentsStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetInitialPast(OnGetInitialPast event,
      Emitter<DisplayAppointmentsState> emit) async {
    try {
      emit(state.copyWith(status: DisplayAppointmentsStatus.initialLoading));

      int page = 0;

      List<Appointment> appointments = await appointmentRepository.getPastAppointments(page);

      bool isLoadingMore = appointments.isEmpty || appointments.length < 10 ? false : true;
      emit(state.copyWith(
        status: DisplayAppointmentsStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        appointments: appointments,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayAppointmentsStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetNextPart(OnGetNextPart event, Emitter<DisplayAppointmentsState> emit) async {
    try {
      if (state.status == DisplayAppointmentsStatus.success) {
        emit(state.copyWith(status: DisplayAppointmentsStatus.loading));
      } else if ((state.status == DisplayAppointmentsStatus.initial)) {
        emit(state.copyWith(status: DisplayAppointmentsStatus.initialLoading));
      } else if ((state.status == DisplayAppointmentsStatus.loading) ||
          (state.status == DisplayAppointmentsStatus.initialLoading)) {
        return;
      }

      int page = state.page + 1;

      List<Appointment> oldAppointments = List<Appointment>.from(state.appointments);

      List<Appointment> appointments = await appointmentRepository.getPastAppointments(page);

      oldAppointments.addAll(appointments);
      bool isLoadingMore = appointments.isEmpty ? false : true;

      emit(state.copyWith(
        status: DisplayAppointmentsStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        appointments: oldAppointments,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayAppointmentsStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onDeleteAppointmentUpComings(OnDeleteAppointmentUpComings event,
      Emitter<DisplayAppointmentsState> emit) async {
    emit(state.copyWith(status: DisplayAppointmentsStatus.initialLoading));

    final appointments = state.appointments;
    appointments.removeWhere((appointment) => appointment.id == event.id);

    emit(state.copyWith(status: DisplayAppointmentsStatus.success));
  }

  @override
  Future<void> close() {
    _appointmentRepositoryEventSubscription.cancel();
    return super.close();
  }
}
