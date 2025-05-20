part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserError extends UserState {
  final AppException? exception;

  UserError({this.exception});
}

enum GetCloseMembersStatus {
  initial,
  loading,
  success,
  error,
}

class UserLoaded extends UserState {
  final User user;
  final GetCloseMembersStatus getCloseMembersStatus;
  final AppException? exception;

  UserLoaded(
    this.user, {
    this.getCloseMembersStatus = GetCloseMembersStatus.initial,
    this.exception,
  });

  UserLoaded copyWith({
    GetCloseMembersStatus? getCloseMembersStatus,
    User? user,
    AppException? exception,
  }) {
    return UserLoaded(
      user ?? this.user,
      getCloseMembersStatus: getCloseMembersStatus ?? this.getCloseMembersStatus,
      exception: exception ?? this.exception,
    );
  }
}
