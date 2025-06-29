part of 'doctor_recruitment_bloc.dart';

@immutable
sealed class DoctorRecruitmentEvent {}

class OnDoctorRecruitment extends DoctorRecruitmentEvent {
  final String firstName;
  final String lastName;

  OnDoctorRecruitment({
    required this.firstName,
    required this.lastName,
  });
}
