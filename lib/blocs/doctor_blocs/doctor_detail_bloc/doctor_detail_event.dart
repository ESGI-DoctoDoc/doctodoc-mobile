part of 'doctor_detail_bloc.dart';

@immutable
sealed class DoctorDetailEvent {}

class OnGetDoctorDetail extends DoctorDetailEvent {
  final String id;

  OnGetDoctorDetail({
    required this.id,
  });
}
