import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/appointment.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_repository/appointment_repository.dart';
import 'package:meta/meta.dart';

part 'display_appointment_event.dart';
part 'display_appointment_state.dart';

class DisplayAppointmentBloc extends Bloc<DisplayAppointmentEvent, DisplayAppointmentState> {
  final AppointmentRepository appointmentRepository;

  DisplayAppointmentBloc({
    required this.appointmentRepository,
  }) : super(DisplayAppointmentState()) {
    on<OnGetAllUpComing>(_onGetAllUpComing);
  }

  Future<void> _onGetAllUpComing(
      OnGetAllUpComing event, Emitter<DisplayAppointmentState> emit) async {
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

      List<Appointment> appointments = await appointmentRepository.getAllUpComing(page);

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
}
