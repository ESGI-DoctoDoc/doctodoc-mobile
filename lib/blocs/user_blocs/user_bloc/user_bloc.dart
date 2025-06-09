import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/services/repositories/close_member_repository/close_member_repository.dart';
import 'package:doctodoc_mobile/services/repositories/close_member_repository/close_member_repository_event.dart';
import 'package:doctodoc_mobile/services/repositories/user_repository/user_repository.dart';
import 'package:doctodoc_mobile/services/repositories/user_repository/user_repository_event.dart';
import 'package:meta/meta.dart';

import '../../../models/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final CloseMemberRepository closeMemberRepository;

  late StreamSubscription _closeMemberRepositoryEventSubscription;
  late StreamSubscription _userRepositoryEventSubscription;

  UserBloc({
    required this.userRepository,
    required this.closeMemberRepository,
  }) : super(UserInitial()) {
    on<OnUserLoadedBasicInfos>(_onUserLoadedBasicInfos);
    on<OnUserUpdatedProfileInfos>(_onUserUpdatedProfileInfos);

    on<OnUserLoadedCloseMembers>(_onUserLoadedCloseMembers);
    on<OnUserAddCloseMembers>(_onUserAddCloseMembers);
    on<OnUserUpdateCloseMember>(_onUserUpdateCloseMember);
    on<OnUserDeleteCloseMember>(_onUserDeleteCloseMember);

    _closeMemberRepositoryEventSubscription =
        closeMemberRepository.closeMemberRepositoryEventStream.listen((event) {
      if (event is CreatedCloseMemberEvent) {
        add(OnUserAddCloseMembers(
          closeMember: event.closeMember,
        ));
      }

      if (event is UpdatedCloseMemberEvent) {
        add(OnUserUpdateCloseMember(
          closeMember: event.closeMember,
        ));
      }

      if (event is DeletedCloseMemberEvent) {
        add(OnUserDeleteCloseMember(
          id: event.id,
        ));
      }
    });

    _userRepositoryEventSubscription = userRepository.userRepositoryEventStream.listen((event) {
      if (event is UpdatedProfileEvent) {
        add(OnUserUpdatedProfileInfos(
          updatedProfile: event.updatedProfile,
        ));
      }
    });
  }

  Future<void> _onUserLoadedBasicInfos(
      OnUserLoadedBasicInfos event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final user = await userRepository.getUser();
      emit(UserLoaded(user));
    } catch (error) {
      emit(UserError(exception: AppException.from(error)));
    }
  }

  Future<void> _onUserUpdatedProfileInfos(
      OnUserUpdatedProfileInfos event, Emitter<UserState> emit) async {
    if (state is! UserLoaded) return;
    final currentState = state as UserLoaded;
    emit(UserLoading());

    final updatedProfile = event.updatedProfile;
    final currentUser = currentState.user;

    currentUser.patientInfos = Patient(
      id: updatedProfile.id,
      lastName: updatedProfile.lastName,
      firstName: updatedProfile.firstName,
      gender: updatedProfile.gender,
      email: updatedProfile.email,
      phoneNumber: updatedProfile.phoneNumber,
      birthdate: updatedProfile.birthdate,
    );
    emit(UserLoaded(currentUser));
  }

  Future<void> _onUserLoadedCloseMembers(
      OnUserLoadedCloseMembers event, Emitter<UserState> emit) async {
    if (state is! UserLoaded) return;

    final currentState = state as UserLoaded;

    try {
      emit(currentState.copyWith(getCloseMembersStatus: GetCloseMembersStatus.loading));
      final closesMembers = await userRepository.getCloseMembers();

      final user = currentState.user;
      user.closeMembers = closesMembers;

      emit(currentState.copyWith(user: user, getCloseMembersStatus: GetCloseMembersStatus.success));
    } catch (error) {
      if (state is! UserLoaded) {
        emit(UserError(exception: AppException.from(error)));
      } else {
        final currentState = state as UserLoaded;
        emit(currentState.copyWith(getCloseMembersStatus: GetCloseMembersStatus.error));
      }
    }
  }

  Future<void> _onUserAddCloseMembers(OnUserAddCloseMembers event, Emitter<UserState> emit) async {
    if (state is! UserLoaded) return;

    final currentState = state as UserLoaded;

    emit(currentState.copyWith(getCloseMembersStatus: GetCloseMembersStatus.loading));

    final closesMembers = currentState.user.closeMembers;
    closesMembers.add(event.closeMember);
    final user = currentState.user;
    user.closeMembers = closesMembers;

    emit(currentState.copyWith(user: user, getCloseMembersStatus: GetCloseMembersStatus.success));
  }

  Future<void> _onUserUpdateCloseMember(
      OnUserUpdateCloseMember event, Emitter<UserState> emit) async {
    if (state is! UserLoaded) return;

    final currentState = state as UserLoaded;

    emit(currentState.copyWith(getCloseMembersStatus: GetCloseMembersStatus.loading));

    final closesMembers = currentState.user.closeMembers;
    final closeMemberToUpdateIndex =
        closesMembers.indexWhere((closeMember) => closeMember.id == event.closeMember.id);
    closesMembers[closeMemberToUpdateIndex] = event.closeMember;

    final user = currentState.user;
    user.closeMembers = closesMembers;

    emit(currentState.copyWith(user: user, getCloseMembersStatus: GetCloseMembersStatus.success));
  }

  Future<void> _onUserDeleteCloseMember(
      OnUserDeleteCloseMember event, Emitter<UserState> emit) async {
    if (state is! UserLoaded) return;

    final currentState = state as UserLoaded;

    emit(currentState.copyWith(getCloseMembersStatus: GetCloseMembersStatus.loading));

    final closesMembers = currentState.user.closeMembers;
    closesMembers.removeWhere((closeMember) => closeMember.id == event.id);

    final user = currentState.user;
    user.closeMembers = closesMembers;

    emit(currentState.copyWith(user: user, getCloseMembersStatus: GetCloseMembersStatus.success));
  }

  @override
  Future<void> close() {
    _closeMemberRepositoryEventSubscription.cancel();
    _userRepositoryEventSubscription.cancel();
    return super.close();
  }
}
