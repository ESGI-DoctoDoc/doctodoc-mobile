import 'package:doctodoc_mobile/blocs/register_bloc/register_bloc.dart';
import 'package:doctodoc_mobile/screens/home_screen.dart';
import 'package:doctodoc_mobile/screens/introduction_screen.dart';
import 'package:doctodoc_mobile/screens/onboarding/onboarding_screen.dart';
import 'package:doctodoc_mobile/services/data_sources/auth_data_source/remote_auth_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/local_auth_data_source/shared_preferences_auth_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/register_data_source/remote_register_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/user_data_source/remote_user_data_source.dart';
import 'package:doctodoc_mobile/services/dio_client.dart';
import 'package:doctodoc_mobile/services/repositories/auth_repository/auth_repository.dart';
import 'package:doctodoc_mobile/services/repositories/register_repository/register_repository.dart';
import 'package:doctodoc_mobile/services/repositories/user_repository/user_repository.dart';
import 'package:doctodoc_mobile/shared/config/dynamic_router_config.dart';
import 'package:doctodoc_mobile/shared/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/auth_bloc/auth_bloc.dart';

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
    nextScreen = const HomeScreen();
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
            create: (context) => RegisterBloc(
              registerRepository: context.read<RegisterRepository>(),
            ),
          ),
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
