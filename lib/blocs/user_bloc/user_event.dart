part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class OnUserLoadedBasicInfos extends UserEvent {}

class OnUserLoadedCloseMembers extends UserEvent {}
