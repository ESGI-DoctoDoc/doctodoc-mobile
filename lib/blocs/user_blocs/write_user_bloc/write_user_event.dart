part of 'write_user_bloc.dart';

@immutable
sealed class WriteUserEvent {}

class OnUpdateProfile extends WriteUserEvent {
  final String firstName;
  final String lastName;
  final String birthdate;
  final String gender;

  OnUpdateProfile({
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
  });
}
