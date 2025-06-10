import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/doctor/doctor_detailed.dart';
import 'package:doctodoc_mobile/services/repositories/doctor_repository/doctor_repository.dart';
import 'package:meta/meta.dart';

part 'doctor_detail_event.dart';
part 'doctor_detail_state.dart';

class DoctorDetailBloc extends Bloc<DoctorDetailEvent, DoctorDetailState> {
  final DoctorRepository doctorRepository;

  DoctorDetailBloc({
    required this.doctorRepository,
  }) : super(DoctorDetailInitial()) {
    on<OnGetDoctorDetail>((event, emit) async {
      try {
        emit(DoctorDetailLoading());
        DoctorDetailed doctor = await doctorRepository.get(event.id);
        emit(DoctorDetailLoaded(doctor: doctor));
      } catch (error) {
        emit(DoctorDetailError(exception: AppException.from(error)));
      }
    });
  }
}
