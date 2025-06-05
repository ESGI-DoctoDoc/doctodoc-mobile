part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class OnUserLoadedBasicInfos extends UserEvent {}

class OnUserLoadedCloseMembers extends UserEvent {}

class OnUserAddCloseMembers extends UserEvent {
  final Patient closeMember;

  OnUserAddCloseMembers({
    required this.closeMember,
  });
}

class OnUserUpdateCloseMember extends UserEvent {
  final Patient closeMember;

  OnUserUpdateCloseMember({
    required this.closeMember,
  });
}

class OnUserDeleteCloseMember extends UserEvent {
  final String id;

  OnUserDeleteCloseMember({
    required this.id,
  });
}
