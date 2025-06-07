part of 'display_appointment_bloc.dart';

enum DisplayAppointmentStatus { initial, initialLoading, loading, success, error }

class DisplayAppointmentState {
  final DisplayAppointmentStatus status;
  final int page;
  final bool isLoadingMore;
  final List<Appointment> appointments;
  final AppException? exception;

  DisplayAppointmentState({
    this.status = DisplayAppointmentStatus.initial,
    this.page = -1,
    this.isLoadingMore = true,
    this.appointments = const [],
    this.exception,
  });

  DisplayAppointmentState copyWith({
    DisplayAppointmentStatus? status,
    int? page,
    List<Appointment>? appointments,
    bool? isLoadingMore,
    AppException? exception,
  }) {
    return DisplayAppointmentState(
      status: status ?? this.status,
      page: page ?? this.page,
      appointments: appointments ?? this.appointments,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      exception: exception ?? this.exception,
    );
  }
}
