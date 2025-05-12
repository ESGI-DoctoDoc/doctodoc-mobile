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
    on<OnBoarding>(_onBoarding);
  }

  Future<void> _onRegister(
      OnRegister event, Emitter<RegisterState> emit) async {
    try {
      emit(state.copyWith(registerStatus: RegisterStatus.loading));

      String email = event.email;
      String password = event.password;
      String phoneNumber = event.phoneNumber;

      await registerRepository.register(email, password, phoneNumber);

      emit(state.copyWith(registerStatus: RegisterStatus.registered));
    } catch (error) {
      emit(state.copyWith(
        registerStatus: RegisterStatus.error,
        exception: AppException.from(error),
      ));
    }
  }

  Future<void> _onBoarding(
      OnBoarding event, Emitter<RegisterState> emit) async {
    try {
      emit(state.copyWith(onBoardingStatus: OnBoardingStatus.loading));

      String firstName = event.firstName;
      String lastName = event.lastName;
      String birthdate = event.birthdate;
      String? referentDoctorId = event.referentDoctorId;

      await registerRepository.onBoarding(
        firstName,
        lastName,
        birthdate,
        referentDoctorId,
      );

      emit(state.copyWith(onBoardingStatus: OnBoardingStatus.onBoarded));
    } catch (error) {
      emit(state.copyWith(
        onBoardingStatus: OnBoardingStatus.error,
        exception: AppException.from(error),
      ));
    }
  }
}
