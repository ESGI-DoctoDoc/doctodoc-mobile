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

class OnBoarding extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String birthdate;
  final String? referentDoctorId;

  OnBoarding({
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    this.referentDoctorId,
  });
}
