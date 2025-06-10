part of 'doctor_detail_bloc.dart';

sealed class DoctorDetailState {}

class DoctorDetailInitial extends DoctorDetailState {}

class DoctorDetailLoading extends DoctorDetailState {}

class DoctorDetailError extends DoctorDetailState {
  final AppException exception;

  DoctorDetailError({
    required this.exception,
  });
}

class DoctorDetailLoaded extends DoctorDetailState {
  final DoctorDetailed doctor;

  DoctorDetailLoaded({
    required this.doctor,
  });

  DoctorDetailLoaded copyWith({
    DoctorDetailed? doctor,
  }) {
    return DoctorDetailLoaded(
      doctor: doctor ?? this.doctor,
    );
  }
}
