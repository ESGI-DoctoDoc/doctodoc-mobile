import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/appointment/appointment.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_repository/appointment_repository.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_repository/appointment_repository_event.dart';
import 'package:meta/meta.dart';

part 'display_appointment_event.dart';
part 'display_appointment_state.dart';

class DisplayAppointmentBloc extends Bloc<DisplayAppointmentEvent, DisplayAppointmentState> {
  final AppointmentRepository appointmentRepository;

  late StreamSubscription _appointmentRepositoryEventSubscription;

  DisplayAppointmentBloc({
    required this.appointmentRepository,
  }) : super(DisplayAppointmentState()) {
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

  Future<void> _onGetInitial(
      OnGetInitialUpComing event, Emitter<DisplayAppointmentState> emit) async {
    try {
      emit(state.copyWith(status: DisplayAppointmentStatus.initialLoading));

      int page = 0;

      List<Appointment> appointments = await appointmentRepository.getUpComing(page);

      bool isLoadingMore = appointments.isEmpty || appointments.length < 10 ? false : true;
      emit(state.copyWith(
        status: DisplayAppointmentStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        appointments: appointments,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayAppointmentStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetNextUpComing(
      OnGetNextUpComing event, Emitter<DisplayAppointmentState> emit) async {
    try {
      if (state.status == DisplayAppointmentStatus.success) {
        emit(state.copyWith(status: DisplayAppointmentStatus.loading));
      } else if ((state.status == DisplayAppointmentStatus.initial)) {
        emit(state.copyWith(status: DisplayAppointmentStatus.initialLoading));
      } else if ((state.status == DisplayAppointmentStatus.loading) ||
          (state.status == DisplayAppointmentStatus.initialLoading)) {
        return;
      }

      int page = state.page + 1;

      List<Appointment> oldAppointments = List<Appointment>.from(state.appointments);

      List<Appointment> appointments = await appointmentRepository.getUpComing(page);

      oldAppointments.addAll(appointments);
      bool isLoadingMore = appointments.isEmpty ? false : true;

      emit(state.copyWith(
        status: DisplayAppointmentStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        appointments: oldAppointments,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayAppointmentStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetInitialPast(
      OnGetInitialPast event, Emitter<DisplayAppointmentState> emit) async {
    try {
      emit(state.copyWith(status: DisplayAppointmentStatus.initialLoading));

      int page = 0;

      List<Appointment> appointments = await appointmentRepository.getPastAppointments(page);

      bool isLoadingMore = appointments.isEmpty || appointments.length < 10 ? false : true;
      emit(state.copyWith(
        status: DisplayAppointmentStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        appointments: appointments,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayAppointmentStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetNextPart(OnGetNextPart event, Emitter<DisplayAppointmentState> emit) async {
    try {
      if (state.status == DisplayAppointmentStatus.success) {
        emit(state.copyWith(status: DisplayAppointmentStatus.loading));
      } else if ((state.status == DisplayAppointmentStatus.initial)) {
        emit(state.copyWith(status: DisplayAppointmentStatus.initialLoading));
      } else if ((state.status == DisplayAppointmentStatus.loading) ||
          (state.status == DisplayAppointmentStatus.initialLoading)) {
        return;
      }

      int page = state.page + 1;

      List<Appointment> oldAppointments = List<Appointment>.from(state.appointments);

      List<Appointment> appointments = await appointmentRepository.getPastAppointments(page);

      oldAppointments.addAll(appointments);
      bool isLoadingMore = appointments.isEmpty ? false : true;

      emit(state.copyWith(
        status: DisplayAppointmentStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        appointments: oldAppointments,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayAppointmentStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onDeleteAppointmentUpComings(
      OnDeleteAppointmentUpComings event, Emitter<DisplayAppointmentState> emit) async {
    emit(state.copyWith(status: DisplayAppointmentStatus.initialLoading));

    final appointments = state.appointments;
    appointments.removeWhere((appointment) => appointment.id == event.id);

    emit(state.copyWith(status: DisplayAppointmentStatus.success));
  }

  @override
  Future<void> close() {
    _appointmentRepositoryEventSubscription.cancel();
    return super.close();
  }
}
