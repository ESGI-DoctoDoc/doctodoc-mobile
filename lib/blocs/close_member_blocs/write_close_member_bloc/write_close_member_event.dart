part of 'write_close_member_bloc.dart';

@immutable
sealed class WriteCloseMemberEvent {}

class OnCreateCloseMember extends WriteCloseMemberEvent {
  final String firstName;
  final String lastName;
  final String birthdate;
  final String gender;
  final String email;
  final String phoneNumber;

  OnCreateCloseMember({
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
    required this.email,
    required this.phoneNumber,
  });
}

class OnUpdateCloseMember extends WriteCloseMemberEvent {
  final String id;
  final String firstName;
  final String lastName;
  final String birthdate;
  final String gender;
  final String email;
  final String phoneNumber;

  OnUpdateCloseMember({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
    required this.email,
    required this.phoneNumber,
  });
}

class OnDeleteCloseMember extends WriteCloseMemberEvent {
  final String id;

  OnDeleteCloseMember({
    required this.id,
  });
}
