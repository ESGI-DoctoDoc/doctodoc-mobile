import 'package:flutter/material.dart';

import '../../../services/data_sources/local_auth_data_source/shared_preferences_auth_data_source.dart';
import '../../introcution_screen.dart';

class OnboardingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int step;
  final int numberOfPages;

  const OnboardingAppBar({
    super.key,
    required this.step,
    required this.numberOfPages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text(
            "Vérification du compte",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left_outlined, size: 35),
            onPressed: () => _logoutUser(context),
          ),
        ),
        LinearProgressIndicator(
          value: step / numberOfPages,
          backgroundColor: Colors.grey[300],
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  void _logoutUser(BuildContext context) {
    final sharedPreferences = SharedPreferencesAuthDataSource();
    sharedPreferences.reset();
    IntroductionScreen.navigateTo(context);
  }
}