import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/services/repositories/doctor_repository/doctor_repository.dart';
import 'package:meta/meta.dart';

part 'doctor_recruitment_event.dart';
part 'doctor_recruitment_state.dart';

class DoctorRecruitmentBloc extends Bloc<DoctorRecruitmentEvent, DoctorRecruitmentState> {
  final DoctorRepository doctorRepository;

  DoctorRecruitmentBloc({
    required this.doctorRepository,
  }) : super(DoctorRecruitmentState()) {
    on<OnDoctorRecruitment>(_onDoctorRecruitment);
  }

  Future<void> _onDoctorRecruitment(
      OnDoctorRecruitment event, Emitter<DoctorRecruitmentState> emit) async {
    try {
      emit(state.copyWith(status: DoctorRecruitmentStatus.loading));

      String fistName = event.firstName;
      String lastName = event.lastName;

      await doctorRepository.recruit(fistName, lastName);

      emit(state.copyWith(status: DoctorRecruitmentStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: DoctorRecruitmentStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
