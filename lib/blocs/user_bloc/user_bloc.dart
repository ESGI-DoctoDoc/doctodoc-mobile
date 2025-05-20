import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/services/repositories/user_repository/user_repository.dart';
import 'package:meta/meta.dart';

import '../../models/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({
    required this.userRepository,
  }) : super(UserInitial()) {
    on<OnUserLoadedBasicInfos>(_onUserLoadedBasicInfos);
    on<OnUserLoadedCloseMembers>(_onUserLoadedCloseMembers);
  }

  Future<void> _onUserLoadedBasicInfos(
      OnUserLoadedBasicInfos event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final user = await userRepository.getUser();
      emit(UserLoaded(user));
    } catch (error) {
      emit(UserError(exception: AppException.from(error)));
    }
  }

  Future<void> _onUserLoadedCloseMembers(
      OnUserLoadedCloseMembers event, Emitter<UserState> emit) async {
    if (state is! UserLoaded) return;

    final currentState = state as UserLoaded;

    try {
      emit(currentState.copyWith(getCloseMembersStatus: GetCloseMembersStatus.loading));
      final closesMembers = await userRepository.getCloseMembers();

      final user = currentState.user;
      user.closeMembers = closesMembers;

      emit(currentState.copyWith(user: user, getCloseMembersStatus: GetCloseMembersStatus.success));
    } catch (error) {
      if (state is! UserLoaded) {
        emit(UserError(exception: AppException.from(error)));
      } else {
        final currentState = state as UserLoaded;
        emit(currentState.copyWith(getCloseMembersStatus: GetCloseMembersStatus.error));
      }
    }
  }
}
