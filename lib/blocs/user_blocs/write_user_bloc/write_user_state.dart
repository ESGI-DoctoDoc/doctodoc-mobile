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

enum DeleteAccountStatus {
  initial,
  loading,
  success,
  error,
}

final class WriteUserState {
  final ChangePasswordStatus changePasswordStatus;
  final WriteUserStatus writeUserStatus;
  final RequestPasswordStatus requestPasswordStatus;
  final DeleteAccountStatus deleteAccountStatus;
  final AppException? exception;

  WriteUserState({
    this.writeUserStatus = WriteUserStatus.initial,
    this.changePasswordStatus = ChangePasswordStatus.initial,
    this.requestPasswordStatus = RequestPasswordStatus.initial,
    this.deleteAccountStatus = DeleteAccountStatus.initial,
    this.exception,
  });

  WriteUserState copyWith({
    WriteUserStatus? writeUserStatus,
    ChangePasswordStatus? changePasswordStatus,
    RequestPasswordStatus? requestPasswordStatus,
    DeleteAccountStatus? deleteAccountStatus,
    AppException? exception,
  }) {
    return WriteUserState(
      writeUserStatus: writeUserStatus ?? this.writeUserStatus,
      changePasswordStatus: changePasswordStatus ?? this.changePasswordStatus,
      requestPasswordStatus: requestPasswordStatus ?? this.requestPasswordStatus,
      deleteAccountStatus: deleteAccountStatus ?? this.deleteAccountStatus,
      exception: exception ?? this.exception,
    );
  }
}
