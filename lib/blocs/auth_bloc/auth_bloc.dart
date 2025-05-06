import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../exceptions/app_exception.dart';
import '../../models/credentials.dart';
import '../../services/repositories/auth_repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({
    required this.authRepository,
  }) : super(AuthState()) {
    on<OnFirstFactorAuthentication>(_onFirstFactorAuthentication);
    on<OnSecondFactorAuthentication>(_onSecondFactorAuthentication);
  }

  Future<void> _onFirstFactorAuthentication(
      OnFirstFactorAuthentication event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStatus.loadingFirstFactorAuthentication));

      var email = event.credentials.username;
      var password = event.credentials.password;

      await authRepository.login(email, password);

      emit(state.copyWith(
        status: AuthStatus.firstFactorAuthenticationValidate,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AuthStatus.firstFactorAuthenticationError,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onSecondFactorAuthentication(
      OnSecondFactorAuthentication event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStatus.loadingSecondFactorAuthentication));

      var doubleAuthCode = event.doubleAuthCode;

      await authRepository.validateDoubleAuthCode(doubleAuthCode);

      emit(state.copyWith(status: AuthStatus.authenticated));
    } catch (error) {
      emit(state.copyWith(
        status: AuthStatus.secondFactorAuthenticationError,
        exception: AppException.from(error),
      ));
    }
  }
}
