import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/services/dtos/update_profile_request.dart';
import 'package:doctodoc_mobile/services/repositories/user_repository/user_repository.dart';
import 'package:meta/meta.dart';

import '../../../exceptions/app_exception.dart';

part 'write_user_event.dart';
part 'write_user_state.dart';

class WriteUserBloc extends Bloc<WriteUserEvent, WriteUserState> {
  final UserRepository userRepository;

  WriteUserBloc({
    required this.userRepository,
  }) : super(WriteUserState()) {
    on<OnUpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onUpdateProfile(OnUpdateProfile event, Emitter<WriteUserState> emit) async {
    try {
      emit(state.copyWith(status: WriteUserStatus.loading));

      String firstName = event.firstName;
      String lastName = event.lastName;
      String gender = event.gender;
      String birthdate = event.birthdate;
      UpdateProfileRequest updateProfileRequest = UpdateProfileRequest(
        firstName: firstName,
        lastName: lastName,
        birthdate: birthdate,
        gender: gender,
      );
      userRepository.updateProfile(updateProfileRequest);

      emit(state.copyWith(status: WriteUserStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: WriteUserStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
