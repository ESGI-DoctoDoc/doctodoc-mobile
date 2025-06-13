part of 'appointment_bloc.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

enum AppointmentLockedStatus { success, error }

final class AppointmentLocked extends AppointmentState {
  final AppointmentLockedStatus status;
  final String? appointmentLockedId;
  final AppException? exception;

  AppointmentLocked({
    required this.status,
    this.appointmentLockedId,
    this.exception,
  });

  AppointmentLocked copyWith({
    AppointmentLockedStatus? status,
    String? appointmentLockedId,
    AppException? exception,
  }) {
    return AppointmentLocked(
      status: status ?? this.status,
      appointmentLockedId: appointmentLockedId ?? this.appointmentLockedId,
      exception: exception ?? this.exception,
    );
  }
}

enum AppointmentConfirmStatus { success, error }

final class AppointmentConfirm extends AppointmentState {
  final AppointmentConfirmStatus status;
  final AppException? exception;

  AppointmentConfirm({
    required this.status,
    this.exception,
  });

  AppointmentConfirm copyWith({
    AppointmentConfirmStatus? status,
    AppException? exception,
  }) {
    return AppointmentConfirm(
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}

enum AppointmentCancelStatus { success, loading, error }

final class AppointmentCancel extends AppointmentState {
  final AppointmentCancelStatus status;
  final AppException? exception;

  AppointmentCancel({
    required this.status,
    this.exception,
  });

  AppointmentCancel copyWith({
    AppointmentCancelStatus? status,
    AppException? exception,
  }) {
    return AppointmentCancel(
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}
