import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/doctor/doctor.dart';
import 'package:doctodoc_mobile/services/repositories/referent_doctor_repository/referent_doctor_repository.dart';
import 'package:meta/meta.dart';

part 'display_referent_doctor_event.dart';
part 'display_referent_doctor_state.dart';

class DisplayReferentDoctorBloc
    extends Bloc<DisplayReferentDoctorEvent, DisplayReferentDoctorState> {
  final ReferentDoctorRepository referentDoctorRepository;

  DisplayReferentDoctorBloc({
    required this.referentDoctorRepository,
  }) : super(ReferentDoctorInitial()) {
    on<OnGetReferentDoctor>(_onGetReferentDoctor);
  }

  Future<void> _onGetReferentDoctor(
      OnGetReferentDoctor event, Emitter<DisplayReferentDoctorState> emit) async {
    try {
      emit(ReferentDoctorLoading());
      final doctor = await referentDoctorRepository.get();

      if (doctor == null) {
        emit(ReferentDoctorEmpty());
      } else {
        emit(ReferentDoctorLoaded(doctor: doctor));
      }
    } catch (error) {
      emit(ReferentDoctorError(exception: AppException.from(error)));
    }
  }
}
