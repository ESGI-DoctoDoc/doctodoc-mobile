part of 'display_detail_close_member_bloc.dart';

@immutable
sealed class DisplayDetailCloseMemberEvent {}

class OnLoadDetailCloseMember extends DisplayDetailCloseMemberEvent {
  final String id;

  OnLoadDetailCloseMember({
    required this.id,
  });
}

class OnLoadUpdateDetailCloseMember extends DisplayDetailCloseMemberEvent {
  final Patient closeMember;

  OnLoadUpdateDetailCloseMember({
    required this.closeMember,
  });
}
