import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/services/repositories/referent_doctor_repository/referent_doctor_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';

part 'write_referent_doctor_event.dart';
part 'write_referent_doctor_state.dart';

class WriteReferentDoctorBloc extends Bloc<WriteReferentDoctorEvent, WriteReferentDoctorState> {
  final ReferentDoctorRepository referentDoctorRepository;

  WriteReferentDoctorBloc({
    required this.referentDoctorRepository,
  }) : super(WriteReferentDoctorState()) {
    on<OnSetReferentDoctor>(_onSetReferentDoctor);
  }

  Future<void> _onSetReferentDoctor(
      OnSetReferentDoctor event, Emitter<WriteReferentDoctorState> emit) async {
    try {
      emit(state.copyWith(status: WriteReferentDoctorStatus.loading));
      await referentDoctorRepository.set(event.doctorId);
      emit(state.copyWith(status: WriteReferentDoctorStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: WriteReferentDoctorStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
