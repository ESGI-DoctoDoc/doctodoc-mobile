part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentEvent {}

class OnGetMedicalConcerns extends AppointmentEvent {}
