import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/patient.dart';
import 'package:doctodoc_mobile/services/repositories/close_member_repository/close_member_repository.dart';
import 'package:meta/meta.dart';

import '../../../services/repositories/close_member_repository/close_member_repository_event.dart';

part 'display_detail_close_member_event.dart';
part 'display_detail_close_member_state.dart';

class DisplayDetailCloseMemberBloc
    extends Bloc<DisplayDetailCloseMemberEvent, DisplayDetailCloseMemberState> {
  final CloseMemberRepository closeMemberRepository;

  late StreamSubscription _closeMemberRepositoryEventSubscription;

  DisplayDetailCloseMemberBloc({
    required this.closeMemberRepository,
  }) : super(DisplayDetailCloseMemberState()) {
    on<OnLoadDetailCloseMember>(_onLoadDetailCloseMember);
    on<OnLoadUpdateDetailCloseMember>(_onLoadUpdateDetailCloseMember);

    _closeMemberRepositoryEventSubscription =
        closeMemberRepository.closeMemberRepositoryEventStream.listen((event) {
      if (event is UpdatedCloseMemberEvent) {
        add(OnLoadUpdateDetailCloseMember(closeMember: event.closeMember));
      }
    });
  }

  Future<void> _onLoadDetailCloseMember(
      OnLoadDetailCloseMember event, Emitter<DisplayDetailCloseMemberState> emit) async {
    try {
      emit(state.copyWith(status: DisplayDetailCloseMemberStatus.loading));

      Patient closeMember = await closeMemberRepository.findById(event.id);

      emit(state.copyWith(
        status: DisplayDetailCloseMemberStatus.success,
        closeMember: closeMember,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DisplayDetailCloseMemberStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onLoadUpdateDetailCloseMember(
      OnLoadUpdateDetailCloseMember event, Emitter<DisplayDetailCloseMemberState> emit) async {
    emit(state.copyWith(status: DisplayDetailCloseMemberStatus.loading));

    Patient closeMember = event.closeMember;

    emit(state.copyWith(
      status: DisplayDetailCloseMemberStatus.success,
      closeMember: closeMember,
    ));
  }

  @override
  Future<void> close() {
    _closeMemberRepositoryEventSubscription.cancel();
    return super.close();
  }
}
