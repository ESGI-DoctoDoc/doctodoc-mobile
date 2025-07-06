import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/models/doctor/doctor.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';
import '../../../services/repositories/search_repository/search_repository.dart';

part 'display_doctor_event.dart';
part 'display_doctor_state.dart';

class DisplayDoctorBloc extends Bloc<DisplayDoctorEvent, DisplayDoctorState> {
  final SearchRepository searchRepository;

  DisplayDoctorBloc({
    required this.searchRepository,
  }) : super(DisplayDoctorState()) {
    on<OnGetInitialSearchDoctor>(_onGetInitialSearchDoctor);
    on<OnGetNextSearchDoctor>(_onGetNextSearchDoctor);
  }

  Future<void> _onGetInitialSearchDoctor(
      OnGetInitialSearchDoctor event, Emitter<DisplayDoctorState> emit) async {
    try {
      emit(state.copyWith(status: DisplayDoctorStatus.initialLoading));

      int page = 0;

      String name = event.name;
      String speciality = event.speciality;
      String languages = event.languages;
      bool valid = event.valid;

      List<Doctor> doctors =
          await searchRepository.searchDoctor(name, speciality, languages, valid, page);

      bool isLoadingMore = doctors.isEmpty || doctors.length < 10 ? false : true;

      emit(state.copyWith(
        status: DisplayDoctorStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        doctors: doctors,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayDoctorStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onGetNextSearchDoctor(
      OnGetNextSearchDoctor event, Emitter<DisplayDoctorState> emit) async {
    try {
      if (state.status == DisplayDoctorStatus.success) {
        emit(state.copyWith(status: DisplayDoctorStatus.loading));
      } else if ((state.status == DisplayDoctorStatus.initial)) {
        emit(state.copyWith(status: DisplayDoctorStatus.initialLoading));
      } else if ((state.status == DisplayDoctorStatus.loading) ||
          (state.status == DisplayDoctorStatus.initialLoading)) {
        return;
      }

      int page = state.page + 1;

      List<Doctor> oldDoctors = List<Doctor>.from(state.doctors);

      String name = event.name;
      String speciality = event.speciality;
      String languages = event.languages;
      bool valid = event.valid;

      List<Doctor> doctors =
          await searchRepository.searchDoctor(name, speciality, languages, valid, page);

      oldDoctors.addAll(doctors);
      bool isLoadingMore = doctors.isEmpty ? false : true;

      emit(state.copyWith(
        status: DisplayDoctorStatus.success,
        page: page,
        isLoadingMore: isLoadingMore,
        doctors: oldDoctors,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayDoctorStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
