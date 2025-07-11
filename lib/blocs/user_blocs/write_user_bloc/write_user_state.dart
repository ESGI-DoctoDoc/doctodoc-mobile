part of 'write_user_bloc.dart';

enum WriteUserStatus {
  initial,
  loading,
  success,
  error,
}

enum ChangePasswordStatus {
  initial,
  loading,
  success,
  error,
}

enum RequestPasswordStatus {
  initial,
  loading,
  success,
  error,
}

final class WriteUserState {
  final ChangePasswordStatus changePasswordStatus;
  final WriteUserStatus writeUserStatus;
  final RequestPasswordStatus requestPasswordStatus;
  final AppException? exception;

  WriteUserState({
    this.writeUserStatus = WriteUserStatus.initial,
    this.changePasswordStatus = ChangePasswordStatus.initial,
    this.requestPasswordStatus = RequestPasswordStatus.initial,
    this.exception,
  });

  WriteUserState copyWith({
    WriteUserStatus? writeUserStatus,
    ChangePasswordStatus? changePasswordStatus,
    RequestPasswordStatus? requestPasswordStatus,
    AppException? exception,
  }) {
    return WriteUserState(
      writeUserStatus: writeUserStatus ?? this.writeUserStatus,
      changePasswordStatus: changePasswordStatus ?? this.changePasswordStatus,
      requestPasswordStatus: requestPasswordStatus ?? this.requestPasswordStatus,
      exception: exception ?? this.exception,
    );
  }
}
