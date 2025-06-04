part of 'write_close_member_bloc.dart';

// @immutable
// sealed class WriteCloseMemberState {}

// final class WriteCloseMemberInitial extends WriteCloseMemberState {}

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

// enum UpdateCloseMemberStatus {
//   loading,
//   success,
//   error,
// }
//
// final class UpdateCloseMemberState extends WriteCloseMemberState {
//   final UpdateCloseMemberStatus status;
//   final AppException? exception;
//
//   UpdateCloseMemberState({
//     required this.status,
//     this.exception,
//   });
// }
