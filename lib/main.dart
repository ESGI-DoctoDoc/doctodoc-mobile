import 'package:doctodoc_mobile/screens/introcution_screen.dart';
import 'package:doctodoc_mobile/services/data_sources/auth_data_source/remote_auth_data_source.dart';
import 'package:doctodoc_mobile/services/data_sources/local_auth_data_source/shared_preferences_auth_data_source.dart';
import 'package:doctodoc_mobile/services/dio_client.dart';
import 'package:doctodoc_mobile/services/repositories/auth_repository/auth_repository.dart';
import 'package:doctodoc_mobile/shared/config/dynamic_router_config.dart';
import 'package:doctodoc_mobile/shared/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/auth_bloc/auth_bloc.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: SafeArea(
          child: MaterialApp(
              title: titleApp,
              onGenerateRoute: DynamicRouterConfig.generateRoute,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: ThemeMode.system,
              home: const IntroductionScreen()),
        ),
      ),
    );
  }
}
