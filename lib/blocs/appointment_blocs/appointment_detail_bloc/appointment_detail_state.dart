part of 'appointment_detail_bloc.dart';

sealed class AppointmentDetailState {}

class AppointmentDetailInitial extends AppointmentDetailState {}

class AppointmentDetailLoading extends AppointmentDetailState {}

class AppointmentDetailError extends AppointmentDetailState {
  final AppException exception;

  AppointmentDetailError({
    required this.exception,
  });
}

class AppointmentDetailLoaded extends AppointmentDetailState {
  final AppointmentDetailed appointment;

  AppointmentDetailLoaded({
    required this.appointment,
  });

  AppointmentDetailLoaded copyWith({
    AppointmentDetailed? appointment,
  }) {
    return AppointmentDetailLoaded(
      appointment: appointment ?? this.appointment,
    );
  }
}
