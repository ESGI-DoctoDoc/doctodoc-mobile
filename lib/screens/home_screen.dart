import 'package:doctodoc_mobile/screens/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctodoc_mobile/blocs/auth_bloc/auth_bloc.dart';

import '../services/data_sources/local_auth_data_source/shared_preferences_auth_data_source.dart';

class HomeScreen extends StatefulWidget {
  static navigateTo(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final sharedPreferences = SharedPreferencesAuthDataSource();
                  await sharedPreferences.reset();
                  IntroductionScreen.navigateTo(context);
                },
              )
            ],
          ),
          body: const Center(
            child: Text(
              'Home Screen',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    );
  }
}
