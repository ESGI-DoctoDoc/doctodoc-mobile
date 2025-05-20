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
    on<OnUserLoaded>(_onUserLoaded);
    add(OnUserLoaded());
  }

  Future<void> _onUserLoaded(OnUserLoaded event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final user = await userRepository.getUser();
      emit(UserLoaded(user));
    } catch (error) {
      emit(UserError(exception: AppException.from(error)));
    }
  }
}
