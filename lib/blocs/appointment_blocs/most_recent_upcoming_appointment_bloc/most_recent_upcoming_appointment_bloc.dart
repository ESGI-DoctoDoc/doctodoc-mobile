import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/appointment/appointment.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_repository/appointment_repository.dart';
import 'package:meta/meta.dart';

import '../../../services/repositories/appointment_repository/appointment_repository_event.dart';

part 'most_recent_upcoming_appointment_event.dart';
part 'most_recent_upcoming_appointment_state.dart';

class MostRecentUpcomingAppointmentBloc
    extends Bloc<MostRecentUpcomingAppointmentEvent, MostRecentUpcomingAppointmentState> {
  final AppointmentRepository appointmentRepository;

  late StreamSubscription _appointmentRepositoryEventSubscription;

  MostRecentUpcomingAppointmentBloc({
    required this.appointmentRepository,
  }) : super(MostRecentUpcomingAppointmentState()) {
    on<OnGet>(_onGet);

    _appointmentRepositoryEventSubscription =
        appointmentRepository.appointmentRepositoryEventStream.listen((event) {
      if (event is CancelAppointmentEvent) {
        add(OnGet());
      }
    });
  }

  Future<void> _onGet(MostRecentUpcomingAppointmentEvent event,
      Emitter<MostRecentUpcomingAppointmentState> emit) async {
    try {
      emit(state.copyWith(status: MostRecentUpcomingAppointmentStatus.loading));

      Appointment? appointment = await appointmentRepository.getMostRecentUpComingAppointment();

      emit(state.copyWith(
        status: MostRecentUpcomingAppointmentStatus.success,
        appointment: appointment,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: MostRecentUpcomingAppointmentStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  @override
  Future<void> close() {
    _appointmentRepositoryEventSubscription.cancel();
    return super.close();
  }
}
