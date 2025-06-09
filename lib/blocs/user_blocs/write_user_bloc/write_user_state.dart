part of 'write_user_bloc.dart';

enum WriteUserStatus {
  initial,
  loading,
  success,
  error,
}

final class WriteUserState {
  final WriteUserStatus status;
  final AppException? exception;

  WriteUserState({
    this.status = WriteUserStatus.initial,
    this.exception,
  });

  WriteUserState copyWith({
    WriteUserStatus? status,
    AppException? exception,
  }) {
    return WriteUserState(
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}
