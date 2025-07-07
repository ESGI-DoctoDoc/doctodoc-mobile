part of 'write_referent_doctor_bloc.dart';

@immutable
sealed class WriteReferentDoctorEvent {}

class OnSetReferentDoctor extends WriteReferentDoctorEvent {
  final String doctorId;

  OnSetReferentDoctor({
    required this.doctorId,
  });
}
