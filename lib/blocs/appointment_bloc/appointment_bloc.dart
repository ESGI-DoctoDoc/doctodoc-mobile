import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern.dart';
import 'package:meta/meta.dart';

import '../../exceptions/app_exception.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

// todo fais le bloc
class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(AppointmentState()) {
    on<OnGetMedicalConcerns>(_onGetMedicalConcerns);
  }

  Future<void> _onGetMedicalConcerns(
      OnGetMedicalConcerns event, Emitter<AppointmentState> emit) async {}
}
