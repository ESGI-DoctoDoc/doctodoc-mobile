import 'package:doctodoc_mobile/models/doctor/doctor.dart';

abstract class ReferentDoctorEvent {}

class SetReferentDoctor extends ReferentDoctorEvent {
  final Doctor doctor;

  SetReferentDoctor({required this.doctor});
}
