part of 'display_referent_doctor_bloc.dart';

abstract class DisplayReferentDoctorState {}

class ReferentDoctorInitial extends DisplayReferentDoctorState {}

class ReferentDoctorLoading extends DisplayReferentDoctorState {}

class ReferentDoctorError extends DisplayReferentDoctorState {
  final AppException exception;

  ReferentDoctorError({
    required this.exception,
  });
}

class ReferentDoctorEmpty extends DisplayReferentDoctorState {}

class ReferentDoctorLoaded extends DisplayReferentDoctorState {
  final Doctor doctor;

  ReferentDoctorLoaded({
    required this.doctor,
  });
}
