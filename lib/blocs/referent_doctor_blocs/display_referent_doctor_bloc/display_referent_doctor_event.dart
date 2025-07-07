part of 'display_referent_doctor_bloc.dart';

@immutable
sealed class DisplayReferentDoctorEvent {}

class OnGetReferentDoctor extends DisplayReferentDoctorEvent {}

class OnUpdateReferentDoctor extends DisplayReferentDoctorEvent {
  final Doctor doctor;

  OnUpdateReferentDoctor({
    required this.doctor,
  });
}
