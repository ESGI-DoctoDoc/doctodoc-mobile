part of 'write_close_member_bloc.dart';

enum WriteCloseMemberStatus {
  initial,
  loading,
  success,
  error,
}

final class WriteCloseMemberState {
  final WriteCloseMemberStatus status;
  final AppException? exception;

  WriteCloseMemberState({
    this.status = WriteCloseMemberStatus.initial,
    this.exception,
  });

  WriteCloseMemberState copyWith({
    WriteCloseMemberStatus? status,
    AppException? exception,
  }) {
    return WriteCloseMemberState(
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}
