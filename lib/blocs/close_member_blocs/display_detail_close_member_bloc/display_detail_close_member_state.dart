part of 'display_detail_close_member_bloc.dart';

enum DisplayDetailCloseMemberStatus { initial, loading, success, error }

class DisplayDetailCloseMemberState {
  final DisplayDetailCloseMemberStatus status;
  final Patient? closeMember;
  final AppException? exception;

  DisplayDetailCloseMemberState({
    this.status = DisplayDetailCloseMemberStatus.initial,
    this.closeMember,
    this.exception,
  });

  DisplayDetailCloseMemberState copyWith({
    DisplayDetailCloseMemberStatus? status,
    Patient? closeMember,
    AppException? exception,
  }) {
    return DisplayDetailCloseMemberState(
      status: status ?? this.status,
      closeMember: closeMember,
      exception: exception ?? this.exception,
    );
  }
}
