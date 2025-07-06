part of 'display_doctor_bloc.dart';

@immutable
sealed class DisplayDoctorEvent {}

class OnGetInitialSearchDoctor extends DisplayDoctorEvent {
  final String name;
  final String speciality;
  final String languages;
  final bool valid;

  OnGetInitialSearchDoctor({
    required this.name,
    required this.speciality,
    required this.languages,
    this.valid = true,
  });
}

class OnGetNextSearchDoctor extends DisplayDoctorEvent {
  final String name;
  final String speciality;
  final String languages;
  final bool valid;

  OnGetNextSearchDoctor({
    required this.name,
    required this.speciality,
    required this.languages,
    this.valid = true,
  });
}
