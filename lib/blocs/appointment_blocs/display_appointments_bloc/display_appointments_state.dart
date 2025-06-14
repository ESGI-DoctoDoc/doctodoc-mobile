part of 'display_appointments_bloc.dart';

enum DisplayAppointmentsStatus { initial, initialLoading, loading, success, error }

class DisplayAppointmentsState {
  final DisplayAppointmentsStatus status;
  final int page;
  final bool isLoadingMore;
  final List<Appointment> appointments;
  final AppException? exception;

  DisplayAppointmentsState({
    this.status = DisplayAppointmentsStatus.initial,
    this.page = -1,
    this.isLoadingMore = true,
    this.appointments = const [],
    this.exception,
  });

  DisplayAppointmentsState copyWith({
    DisplayAppointmentsStatus? status,
    int? page,
    List<Appointment>? appointments,
    bool? isLoadingMore,
    AppException? exception,
  }) {
    return DisplayAppointmentsState(
      status: status ?? this.status,
      page: page ?? this.page,
      appointments: appointments ?? this.appointments,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      exception: exception ?? this.exception,
    );
  }
}
