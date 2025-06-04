import 'package:doctodoc_mobile/models/patient.dart';

abstract class CloseMemberRepositoryEvent {}

class CreatedCloseMemberEvent extends CloseMemberRepositoryEvent {
  final Patient closeMember;

  CreatedCloseMemberEvent(this.closeMember);
}

class UpdatedCloseMemberEvent extends CloseMemberRepositoryEvent {
  final Patient closeMember;

  UpdatedCloseMemberEvent(this.closeMember);
}

class DeletedCloseMemberEvent extends CloseMemberRepositoryEvent {
  final String id;

  DeletedCloseMemberEvent(this.id);
}
