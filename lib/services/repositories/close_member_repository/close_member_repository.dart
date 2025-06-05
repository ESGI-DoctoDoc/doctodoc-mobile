import 'dart:async';

import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/services/data_sources/close_member_data_source/close_member_data_source.dart';

import '../../../exceptions/app_exception.dart';
import '../../dtos/create_close_member_request.dart';
import 'close_member_repository_event.dart';

class CloseMemberRepository {
  final CloseMemberDataSource closeMemberDataSource;

  CloseMemberRepository({
    required this.closeMemberDataSource,
  });

  final _closeMemberRepositoryEventController =
      StreamController<CloseMemberRepositoryEvent>.broadcast();

  Stream<CloseMemberRepositoryEvent> get closeMemberRepositoryEventStream =>
      _closeMemberRepositoryEventController.stream;

  Future<void> create(SaveCloseMemberRequest request) async {
    try {
      Patient patient = await closeMemberDataSource.create(request);
      _closeMemberRepositoryEventController.add(CreatedCloseMemberEvent(patient));
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> update(String id, SaveCloseMemberRequest request) async {
    try {
      Patient patient = await closeMemberDataSource.update(id, request);
      _closeMemberRepositoryEventController.add(UpdatedCloseMemberEvent(patient));
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<void> delete(String id) async {
    try {
      await closeMemberDataSource.delete(id);
      _closeMemberRepositoryEventController.add(DeletedCloseMemberEvent(id));
    } catch (error) {
      throw UnknownException();
    }
  }

  Future<Patient> findById(String id) async {
    try {
      return await closeMemberDataSource.findById(id);
    } catch (error) {
      throw UnknownException();
    }
  }

  dispose() {
    _closeMemberRepositoryEventController.close();
  }
}
