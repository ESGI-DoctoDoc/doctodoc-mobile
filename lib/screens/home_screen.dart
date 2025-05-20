import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/user_bloc/user_bloc.dart';
import '../models/user.dart';
import '../shared/widgets/buttons/primary_button.dart';
import 'appointment/appointment_screen.dart';
import 'introduction_screen.dart';

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
  void initState() {
    super.initState();
    final userBloc = context.read<UserBloc>();
    userBloc.add(OnUserLoadedBasicInfos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return switch (state) {
          UserLoading() || UserInitial() => _buildLoading(context),
          UserLoaded() => _buildSuccess(context, state.user),
          UserError() || UserState() => _buildError(),
        };
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text(
        'Cannot fetch user data',
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, User user) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Home Screen ${user.patientInfos.firstName}',
              style: TextStyle(fontSize: 24),
            ),
          ),
          PrimaryButton(
            label: "prendre rendez-vous",
            onTap: () {
              AppointmentScreen.navigateTo(
                context,
                doctorId: "00000000-0000-0000-0000-000000000001",
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
  }

  void _logout() {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(OnLogout());
    IntroductionScreen.navigateTo(context);
  }
}
