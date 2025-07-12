import 'package:doctodoc_mobile/blocs/auth_bloc/auth_bloc.dart';
import 'package:doctodoc_mobile/blocs/user_blocs/write_user_bloc/write_user_bloc.dart';
import 'package:doctodoc_mobile/screens/introduction_screen.dart';
import 'package:doctodoc_mobile/screens/profile/patients_screen.dart';
import 'package:doctodoc_mobile/screens/profile/profile_screen.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/change_password_modal.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/update_phone_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../blocs/user_blocs/user_bloc/user_bloc.dart';
import '../../models/user.dart';
import '../../shared/utils/show_error_snackbar.dart';
import '../appointment/widgets/onboarding_loading.dart';
import '../medicals/medical_details_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final userBloc = context.read<UserBloc>();
    userBloc.add(OnUserLoadedBasicInfos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            floating: true,
            snap: true,
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text('Compte'),
              background: Container(
                color: Color(0xFFEFEFEF),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Mes informations
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Mes informations',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return switch (state) {
                    UserLoading() || UserInitial() => const OnboardingLoading(),
                    UserLoaded() => _buildProfileSection(state.user),
                    UserError() || UserState() => _buildError(),
                  };
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Ma famille'),
                subtitle: const Text('Gérer les membres de ma famille'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => PatientsScreen.navigateTo(context),
              ),
              ListTile(
                leading: const Icon(Icons.folder_shared),
                title: const Text('Dossier médical'),
                subtitle: const Text('Mes documents médicaux'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => MedicalDetailsScreen.navigateTo(context, patientId: "0"), //Todo me
              ),

              // Moyens de connexion
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Connexion',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return switch (state) {
                    UserLoading() || UserInitial() => const OnboardingLoading(),
                    UserLoaded() => _buildEmailSection(state.user.patientInfos.email),
                    UserError() || UserState() => _buildError(),
                  };
                },
              ),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return switch (state) {
                    UserLoading() || UserInitial() => const OnboardingLoading(),
                    UserLoaded() => _buildPhoneNumberSection(state.user.patientInfos.phoneNumber),
                    UserError() || UserState() => _buildError(),
                  };
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Mot de passe'),
                subtitle: const Text('Modifier mon mot de passe'),
                trailing: const Icon(Icons.edit, size: 18),
                onTap: () => showChangePasswordModal(context),
              ),

              // Confidentialité
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Confidentialité',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Politique de confidentialité'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {}, //Todo add page
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text("Conditions d'utilisation"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {}, //Todo add page
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Déconnexion'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _onLogout(context);
                },
              ),

              const SizedBox(height: 16),
              BlocListener<WriteUserBloc, WriteUserState>(
                listenWhen: (previous, current) {
                  return previous.deleteAccountStatus != current.deleteAccountStatus;
                },
                listener: _deleteAccountListener,
                child: ListTile(
                  leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                  title: Text(
                    'Supprimer mon compte',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.read<WriteUserBloc>().add(OnDeleteAccount());
                  },
                ),
              ),

              const SizedBox(height: 16),

              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: Text("Version indisponible"));
                  final version = snapshot.data!.version;
                  return Center(
                    child: Text(
                      'Version $version',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary.withAlpha(77),
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
            ]),
          ),
        ],
      ),
    );
  }

  void _onLogout(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(OnLogout());
    IntroductionScreen.navigateTo(context);
  }

  ListTile _buildPhoneNumberSection(String phoneNumber) {
    return ListTile(
      leading: const Icon(Icons.phone),
      title: const Text('Numéro de téléphone'),
      subtitle: Text(
        phoneNumber
            .replaceFirst('+33', '0')
            .replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)} ")
            .trim(),
      ),
      trailing: const Icon(Icons.verified, color: Colors.green, size: 18),
      onTap: () => showUpdatePhoneModal(context, phoneNumber),
    );
  }

  ListTile _buildEmailSection(String email) {
    return ListTile(
      leading: const Icon(Icons.email),
      title: Text('Email'),
      subtitle: Text(email),
      trailing: const Icon(Icons.verified, color: Colors.green, size: 18),
    );
  }

  ListTile _buildProfileSection(User user) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: const Text('Profil'),
      // subtitle: const Text('Corentin LECHENE'),
      subtitle: Text("${user.patientInfos.firstName} ${user.patientInfos.lastName}"),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => ProfileDetailsScreen.navigateTo(
        context,
        patientId: user.patientInfos.id,
      ),
    );
  }

  Widget _buildError() {
    return const ListTile(
      title: Text("Une erreur s'est produite."),
      subtitle: Text("Veuillez réessayer plus tard."),
      leading: Icon(Icons.error, color: Colors.red),
    );
  }

  void _deleteAccountListener(BuildContext context, WriteUserState state) async {
    if (state.deleteAccountStatus == DeleteAccountStatus.success) {
      _onLogout(context);
    } else if (state.deleteAccountStatus == DeleteAccountStatus.error) {
      showErrorSnackbar(context, state.exception);
    }
  }
}
