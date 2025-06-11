part of 'appointment_detail_bloc.dart';

@immutable
sealed class AppointmentDetailEvent {}

class OnGetAppointmentDetail extends AppointmentDetailEvent {
  final String id;

  OnGetAppointmentDetail({
    required this.id,
  });
}
