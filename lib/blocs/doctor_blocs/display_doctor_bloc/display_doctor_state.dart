part of 'display_doctor_bloc.dart';

enum DisplayDoctorStatus { initial, initialLoading, loading, success, error }

class DisplayDoctorState {
  final DisplayDoctorStatus status;
  final int page;
  final bool isLoadingMore;
  final List<Doctor> doctors;
  final AppException? exception;

  DisplayDoctorState({
    this.status = DisplayDoctorStatus.initial,
    this.page = -1,
    this.isLoadingMore = true,
    this.doctors = const [],
    this.exception,
  });

  DisplayDoctorState copyWith({
    DisplayDoctorStatus? status,
    int? page,
    List<Doctor>? doctors,
    bool? isLoadingMore,
    AppException? exception,
  }) {
    return DisplayDoctorState(
      status: status ?? this.status,
      page: page ?? this.page,
      doctors: doctors ?? this.doctors,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      exception: exception ?? this.exception,
    );
  }
}
