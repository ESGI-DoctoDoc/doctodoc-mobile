import 'package:doctodoc_mobile/models/patient.dart';

abstract class UserRepositoryEvent {}

class UpdatedProfileEvent extends UserRepositoryEvent {
  final Patient updatedProfile;

  UpdatedProfileEvent({required this.updatedProfile});
}
