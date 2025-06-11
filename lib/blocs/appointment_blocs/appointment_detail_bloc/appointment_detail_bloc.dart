import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_repository/appointment_repository.dart';
import 'package:meta/meta.dart';

import '../../../models/appointment/appointment_detailed.dart';

part 'appointment_detail_event.dart';
part 'appointment_detail_state.dart';

class AppointmentDetailBloc extends Bloc<AppointmentDetailEvent, AppointmentDetailState> {
  final AppointmentRepository appointmentRepository;

  AppointmentDetailBloc({
    required this.appointmentRepository,
  }) : super(AppointmentDetailInitial()) {
    on<OnGetAppointmentDetail>((event, emit) async {
      try {
        emit(AppointmentDetailLoading());
        AppointmentDetailed appointmentDetailed = await appointmentRepository.getById(event.id);
        emit(AppointmentDetailLoaded(appointment: appointmentDetailed));
      } catch (error) {
        emit(AppointmentDetailError(exception: AppException.from(error)));
      }
    });
  }
}
