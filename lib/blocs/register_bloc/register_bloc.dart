import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/services/repositories/register_repository/register_repository.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;

  RegisterBloc({
    required this.registerRepository,
  }) : super(RegisterState()) {
    on<OnRegister>(_onRegister);
  }

  Future<void> _onRegister(
      OnRegister event, Emitter<RegisterState> emit) async {
    try {
      emit(state.copyWith(status: RegisterStatus.loading));

      String email = event.email;
      String password = event.password;
      String phoneNumber = event.phoneNumber;

      await registerRepository.register(email, password, phoneNumber);

      emit(state.copyWith(status: RegisterStatus.registered));
    } catch (error) {
      emit(state.copyWith(
        status: RegisterStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
