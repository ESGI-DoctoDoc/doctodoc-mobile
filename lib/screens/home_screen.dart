import 'package:doctodoc_mobile/screens/appointment/appointment_screen.dart';
import 'package:doctodoc_mobile/screens/introduction_screen.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
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
          body: Column(
            children: [
              const Center(
                child: Text(
                  'Home Screen',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              PrimaryButton(
                label: "prendre rendez-vous",
                onTap: () {
                  AppointmentScreen.navigateTo(context,
                    doctorId: "doctorId",
                    doctorFirstName: "Corentin",
                    doctorLastName: "LECHENE",
                    doctorPictureUrl: "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d",
                    latitude: 48.860640,
                    longitude: 2.510171,
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
