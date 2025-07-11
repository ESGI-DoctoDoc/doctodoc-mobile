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
    on<OnChangePassword>(_onChangePassword);
    on<OnRequestNewPassword>(_onRequestNewPassword);
  }

  Future<void> _onUpdateProfile(OnUpdateProfile event, Emitter<WriteUserState> emit) async {
    try {
      emit(state.copyWith(writeUserStatus: WriteUserStatus.loading));

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
      await userRepository.updateProfile(updateProfileRequest);

      emit(state.copyWith(writeUserStatus: WriteUserStatus.success));
    } catch (error) {
      emit(state.copyWith(
        writeUserStatus: WriteUserStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onChangePassword(OnChangePassword event, Emitter<WriteUserState> emit) async {
    try {
      emit(state.copyWith(changePasswordStatus: ChangePasswordStatus.loading));

      String oldPassword = event.oldPassword;
      String newPassword = event.newPassword;

      await userRepository.updatePassword(oldPassword, newPassword);

      emit(state.copyWith(changePasswordStatus: ChangePasswordStatus.success));
    } catch (error) {
      emit(state.copyWith(
        changePasswordStatus: ChangePasswordStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onRequestNewPassword(
      OnRequestNewPassword event, Emitter<WriteUserState> emit) async {
    try {
      emit(state.copyWith(requestPasswordStatus: RequestPasswordStatus.loading));

      String email = event.email;

      await userRepository.requestNewPassword(email);

      emit(state.copyWith(requestPasswordStatus: RequestPasswordStatus.success));
    } catch (error) {
      emit(state.copyWith(
        requestPasswordStatus: RequestPasswordStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
