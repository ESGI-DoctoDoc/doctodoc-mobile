part of 'report_doctor_bloc.dart';

enum ReportDoctorStatus {
  initial,
  loading,
  success,
  error,
}

class ReportDoctorState {
  final ReportDoctorStatus status;
  final AppException? exception;

  ReportDoctorState({
    this.status = ReportDoctorStatus.initial,
    this.exception,
  });

  ReportDoctorState copyWith({
    ReportDoctorStatus? status,
    AppException? exception,
  }) {
    return ReportDoctorState(
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}
