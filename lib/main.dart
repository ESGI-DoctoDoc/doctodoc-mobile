import 'package:doctodoc_mobile/blocs/close_member_blocs/display_detail_close_member_bloc/display_detail_close_member_bloc.dart';
import 'package:doctodoc_mobile/blocs/display_specialities_bloc/display_specialities_bloc.dart';
import 'package:doctodoc_mobile/blocs/doctor_blocs/display_doctor_bloc/display_doctor_bloc.dart';
import 'package:doctodoc_mobile/blocs/user_blocs/write_user_bloc/write_user_bloc.dart';
import 'package:doctodoc_mobile/screens/introduction_screen.dart';
import 'package:doctodoc_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:doctodoc_mobile/services/data_sources/appointment_data_source/remote_appointment_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/appointment_flow_data_source/remote_appointment_flow_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/auth_data_source/remote_auth_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/close_member_data_source/remote_close_member_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/local_auth_data_source/shared_preferences_auth_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/register_data_source/remote_register_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/search_data_source/remote_search_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/speciality_data_source/remote_speciality_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/user_data_source/remote_user_data_source.dart';
import 'package:doctodoc_mobile/services/dio_client.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_flow_repository/appointment_flow_repository.dart';
import 'package:doctodoc_mobile/services/repositories/appointment_repository/appointment_repository.dart';
import 'package:doctodoc_mobile/services/repositories/auth_repository/auth_repository.dart';
import 'package:doctodoc_mobile/services/repositories/close_member_repository/close_member_repository.dart';
import 'package:doctodoc_mobile/services/repositories/register_repository/register_repository.dart';
import 'package:doctodoc_mobile/services/repositories/search_repository/search_repository.dart';
import 'package:doctodoc_mobile/services/repositories/speciality_repository/speciality_repository.dart';
import 'package:doctodoc_mobile/services/repositories/user_repository/user_repository.dart';
import 'package:doctodoc_mobile/shared/config/dynamic_router_config.dart';
import 'package:doctodoc_mobile/shared/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/appointment_blocs/appointment_bloc/appointment_bloc.dart';
import 'blocs/appointment_blocs/appointment_flow_bloc/appointment_flow_bloc.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/close_member_blocs/write_close_member_bloc/write_close_member_bloc.dart';
import 'blocs/register_bloc/register_bloc.dart';
import 'blocs/user_blocs/user_bloc/user_bloc.dart';
import 'layout/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final sharedPreferences = SharedPreferencesAuthDataSource();
  final isLoggedIn = await sharedPreferences.retrieveToken() != null;
  final hasTwoFactor = await sharedPreferences.hasCompletedTwoFactorAuthentication();
  final hasOnboarded = await sharedPreferences.hasCompletedOnboarding();

  Widget nextScreen = const IntroductionScreen();

  print("Is logged in: $isLoggedIn");
  print("Has completed two-factor authentication: $hasTwoFactor");
  print("Has completed onboarding: $hasOnboarded");
  if (isLoggedIn && hasTwoFactor == false) {
    print("User is logged in but has not completed two-factor authentication");
    await sharedPreferences.reset();
  } else if (isLoggedIn && hasOnboarded == false) {
    print("User is logged in but has not completed onboarding");
    nextScreen = const OnboardingScreen();
  } else if (isLoggedIn && hasTwoFactor == true && hasOnboarded == true) {
    print("User is logged in and has completed onboarding");
    nextScreen = const MainLayout();
  }

  runApp(MyApp(nextScreen: nextScreen));
}

class MyApp extends StatelessWidget {
  final Widget nextScreen;

  const MyApp({super.key, required this.nextScreen});

  static const String titleApp = 'DoctoDoc';

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
              authDataSource: RemoteAuthDataSource(
                dio: DioClient(
                  localAuthDataSource: SharedPreferencesAuthDataSource(),
                ).dio,
              ),
              localAuthDataSource: SharedPreferencesAuthDataSource()),
        ),
        RepositoryProvider(
          create: (context) => RegisterRepository(
            registerDataSource: RemoteRegisterDataSource(
              dio: DioClient(
                localAuthDataSource: SharedPreferencesAuthDataSource(),
              ).dio,
            ),
            localAuthDataSource: SharedPreferencesAuthDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(
            userDataSource: RemoteUserDataSource(
              dio: DioClient(
                localAuthDataSource: SharedPreferencesAuthDataSource(),
              ).dio,
            ),
            localAuthDataSource: SharedPreferencesAuthDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => AppointmentFlowRepository(
            appointmentFlowDataSource: RemoteAppointmentFlowDataSource(
              dio: DioClient(
                localAuthDataSource: SharedPreferencesAuthDataSource(),
              ).dio,
            ),
          ),
        ),
        RepositoryProvider(
          create: (context) => AppointmentRepository(
            appointmentDataSource: RemoteAppointmentDataSource(
              dio: DioClient(
                localAuthDataSource: SharedPreferencesAuthDataSource(),
              ).dio,
            ),
          ),
        ),
        RepositoryProvider(
          create: (context) => CloseMemberRepository(
            closeMemberDataSource: RemoteCloseMemberDataSource(
              dio: DioClient(
                localAuthDataSource: SharedPreferencesAuthDataSource(),
              ).dio,
            ),
          ),
        ),
        RepositoryProvider(
          create: (context) => SearchRepository(
            searchDataSource: RemoteSearchDataSource(
              dio: DioClient(
                localAuthDataSource: SharedPreferencesAuthDataSource(),
              ).dio,
            ),
          ),
        ),
        RepositoryProvider(
          create: (context) => SpecialityRepository(
            specialityDataSource: RemoteSpecialityDataSource(
              dio: DioClient(
                localAuthDataSource: SharedPreferencesAuthDataSource(),
              ).dio,
            ),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              localAuthDataSource: SharedPreferencesAuthDataSource(),
            ),
          ),
          BlocProvider(
            create: (context) => UserBloc(
              userRepository: context.read<UserRepository>(),
              closeMemberRepository: context.read<CloseMemberRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => WriteUserBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => RegisterBloc(
              registerRepository: context.read<RegisterRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AppointmentFlowBloc(
              appointmentFlowRepository: context.read<AppointmentFlowRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AppointmentBloc(
              appointmentRepository: context.read<AppointmentRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => WriteCloseMemberBloc(
              closeMemberRepository: context.read<CloseMemberRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => DisplayDetailCloseMemberBloc(
              closeMemberRepository: context.read<CloseMemberRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => DisplayDoctorBloc(
              searchRepository: context.read<SearchRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => DisplaySpecialitiesBloc(
              specialityRepository: context.read<SpecialityRepository>(),
            ),
          )
        ],
        child: MaterialApp(
          title: titleApp,
          onGenerateRoute: DynamicRouterConfig.generateRoute,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          home: nextScreen,
        ),
      ),
    );
  }
}
