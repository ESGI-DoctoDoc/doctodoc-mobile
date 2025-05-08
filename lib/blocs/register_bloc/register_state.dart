part of 'register_bloc.dart';

enum RegisterStatus {
  initial,
  loading,
  registered,
  error,
}

enum OnBoardingStatus {
  initial,
  loading,
  onBoarded,
  error,
}

class RegisterState {
  final RegisterStatus registerStatus;
  final OnBoardingStatus onBoardingStatus;
  final AppException? exception;

  RegisterState({
    this.registerStatus = RegisterStatus.initial,
    this.onBoardingStatus = OnBoardingStatus.initial,
    this.exception,
  });

  RegisterState copyWith({
    RegisterStatus? registerStatus,
    OnBoardingStatus? onBoardingStatus,
    AppException? exception,
  }) {
    return RegisterState(
      registerStatus: registerStatus ?? this.registerStatus,
      onBoardingStatus: onBoardingStatus ?? this.onBoardingStatus,
      exception: exception ?? this.exception,
    );
  }
}
