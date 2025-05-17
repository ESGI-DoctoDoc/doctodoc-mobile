import 'package:flutter/material.dart';

class AppointmentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String firstname;
  final String lastname;
  final String avatarUrl;
  final Function onBack;

  const AppointmentAppBar({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.avatarUrl,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_outlined, size: 30),
                onPressed: () => onBack(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Adjust radius as needed
                  child: Image.network(
                    avatarUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Rendez-vous avec',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Text(
                    'Dr. $firstname $lastname',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}