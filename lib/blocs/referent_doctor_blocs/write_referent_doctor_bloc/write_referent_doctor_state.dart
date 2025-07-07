part of 'write_referent_doctor_bloc.dart';

enum WriteReferentDoctorStatus {
  initial,
  loading,
  success,
  error,
}

class WriteReferentDoctorState {
  final WriteReferentDoctorStatus status;
  final AppException? exception;

  WriteReferentDoctorState({
    this.status = WriteReferentDoctorStatus.initial,
    this.exception,
  });

  WriteReferentDoctorState copyWith({
    WriteReferentDoctorStatus? status,
    AppException? exception,
  }) {
    return WriteReferentDoctorState(
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}
