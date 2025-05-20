part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class OnFirstFactorAuthentication extends AuthEvent {
  final Credentials credentials;

  OnFirstFactorAuthentication({
    required this.credentials,
  });
}

class OnSecondFactorAuthentication extends AuthEvent {
  final String doubleAuthCode;

  OnSecondFactorAuthentication({
    required this.doubleAuthCode,
  });
}

class OnLogout extends AuthEvent {}
