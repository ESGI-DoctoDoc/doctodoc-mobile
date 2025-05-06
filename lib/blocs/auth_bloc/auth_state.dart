part of 'auth_bloc.dart';

enum AuthStatus {
  notAuthenticated,
  firstFactorAuthenticationValidate,
  firstFactorAuthenticationError,
  secondFactorAuthenticationError,
  authenticated,
  loadingFirstFactorAuthentication,
  loadingSecondFactorAuthentication,
}

class AuthState {
  final AuthStatus status;
  final AppException? exception;

  AuthState({
    this.status = AuthStatus.notAuthenticated,
    this.exception,
  });

  AuthState copyWith({
    AuthStatus? status,
    AppException? exception,
  }) {
    return AuthState(
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}
