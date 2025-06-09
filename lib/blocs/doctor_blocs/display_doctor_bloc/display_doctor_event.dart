part of 'display_doctor_bloc.dart';

@immutable
sealed class DisplayDoctorEvent {}

class OnGetInitialSearchDoctor extends DisplayDoctorEvent {
  final String name;
  final String speciality;
  final String languages;

  OnGetInitialSearchDoctor({
    required this.name,
    required this.speciality,
    required this.languages,
  });
}

class OnGetNextSearchDoctor extends DisplayDoctorEvent {
  final String name;
  final String speciality;
  final String languages;

  OnGetNextSearchDoctor({
    required this.name,
    required this.speciality,
    required this.languages,
  });
}
