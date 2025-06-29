part of 'doctor_recruitment_bloc.dart';

enum DoctorRecruitmentStatus {
  initial,
  loading,
  success,
  error,
}

class DoctorRecruitmentState {
  final DoctorRecruitmentStatus status;
  final AppException? exception;

  DoctorRecruitmentState({
    this.status = DoctorRecruitmentStatus.initial,
    this.exception,
  });

  DoctorRecruitmentState copyWith({
    DoctorRecruitmentStatus? status,
    AppException? exception,
  }) {
    return DoctorRecruitmentState(
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}
