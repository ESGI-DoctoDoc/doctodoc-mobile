part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class OnRegister extends RegisterEvent {
  final String email;
  final String password;
  final String phoneNumber;

  OnRegister({
    required this.email,
    required this.password,
    required this.phoneNumber,
  });
}
