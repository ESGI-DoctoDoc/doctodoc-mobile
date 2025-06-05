import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/services/dtos/create_close_member_request.dart';
import 'package:doctodoc_mobile/services/repositories/close_member_repository/close_member_repository.dart';
import 'package:meta/meta.dart';

part 'write_close_member_event.dart';
part 'write_close_member_state.dart';

class WriteCloseMemberBloc extends Bloc<WriteCloseMemberEvent, WriteCloseMemberState> {
  final CloseMemberRepository closeMemberRepository;

  WriteCloseMemberBloc({
    required this.closeMemberRepository,
  }) : super(WriteCloseMemberState()) {
    on<OnCreateCloseMember>(_onAddCloseMember);
    on<OnUpdateCloseMember>(_onUpdateCloseMember);
    on<OnDeleteCloseMember>(_onDeleteCloseMember);
  }

  Future<void> _onAddCloseMember(
      OnCreateCloseMember event, Emitter<WriteCloseMemberState> emit) async {
    try {
      emit(state.copyWith(status: WriteCloseMemberStatus.loading));

      String firstName = event.firstName;
      String lastName = event.lastName;
      String gender = event.gender;
      String email = event.email;
      String birthdate = event.birthdate;
      String phoneNumber = event.phoneNumber;

      SaveCloseMemberRequest request = SaveCloseMemberRequest(
        firstName: firstName,
        lastName: lastName,
        birthdate: birthdate,
        gender: gender,
        email: email,
        phoneNumber: phoneNumber,
      );

      closeMemberRepository.create(request);

      emit(state.copyWith(status: WriteCloseMemberStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: WriteCloseMemberStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onUpdateCloseMember(
      OnUpdateCloseMember event, Emitter<WriteCloseMemberState> emit) async {
    try {
      emit(state.copyWith(status: WriteCloseMemberStatus.loading));

      String id = event.id;
      String firstName = event.firstName;
      String lastName = event.lastName;
      String gender = event.gender;
      String email = event.email;
      String birthdate = event.birthdate;
      String phoneNumber = event.phoneNumber;

      SaveCloseMemberRequest request = SaveCloseMemberRequest(
        firstName: firstName,
        lastName: lastName,
        birthdate: birthdate,
        gender: gender,
        email: email,
        phoneNumber: phoneNumber,
      );

      closeMemberRepository.update(id, request);

      emit(state.copyWith(status: WriteCloseMemberStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: WriteCloseMemberStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onDeleteCloseMember(
      OnDeleteCloseMember event, Emitter<WriteCloseMemberState> emit) async {
    try {
      emit(state.copyWith(status: WriteCloseMemberStatus.loading));
      closeMemberRepository.delete(event.id);
      emit(state.copyWith(status: WriteCloseMemberStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: WriteCloseMemberStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
