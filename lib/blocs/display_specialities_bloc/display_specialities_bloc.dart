import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/models/speciality.dart';
import 'package:doctodoc_mobile/services/repositories/speciality_repository/speciality_repository.dart';
import 'package:meta/meta.dart';

import '../../exceptions/app_exception.dart';

part 'display_specialities_event.dart';
part 'display_specialities_state.dart';

class DisplaySpecialitiesBloc extends Bloc<DisplaySpecialitiesEvent, DisplaySpecialitiesState> {
  final SpecialityRepository specialityRepository;

  DisplaySpecialitiesBloc({
    required this.specialityRepository,
  }) : super(DisplaySpecialitiesState()) {
    on<OnGetSpecialities>((event, emit) async {
      try {
        emit(state.copyWith(status: DisplaySpecialitiesStatus.loading));
        List<Speciality> specialities = await specialityRepository.getAll();
        emit(state.copyWith(status: DisplaySpecialitiesStatus.success, specialities: specialities));
      } catch (error) {
        emit(state.copyWith(
            status: DisplaySpecialitiesStatus.error, exception: AppException.from(error)));
      }
    });
  }
}
