import 'package:doctodoc_mobile/shared/widgets/buttons/error_button.dart';
import 'package:doctodoc_mobile/shared/widgets/maps/maps_viewer.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AppointmentDetailScreen extends StatefulWidget {
  static const String routeName = '/appointment/:appointmentId';

  static void navigateTo(BuildContext context, String appointmentId) {
    Navigator.pushNamed(context, routeName, arguments: {
      'appointmentId': appointmentId,
    });
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['appointmentId'] is String) {
      return AppointmentDetailScreen(appointmentId: arguments['appointmentId'] as String);
    } else {
      return const Center(child: Text('Invalid appointment ID'));
    }
  }

  final String appointmentId;

  const AppointmentDetailScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFEFEF),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          appBar: AppBar(
            title: const Text('Détails du rendez-vous'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                color: Theme.of(context).primaryColor.withAlpha(50),
                child: Center(
                  child: Text(
                    'Lundi 9 juin 2025 - 14h30',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDoctor('Dr. John Doe', 'Cardiologist', 'https://exemple.jpg'), // TODO
                        _buildPatient('Jane Doe', 'c.lechene@myges.fr', 'Consultation Cardiaque'), // TODO
                        _buildCareTracking(),
                        _buildAddress('9 impasse des Fleurs, 75000 Paris', LatLng(23, 23), 'https://exemple.jpg'), // TODO
                        const SizedBox(height: 16),
                        ErrorButton(
                          label: "Annuler le rendez-vous",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctor(String fullName, String specialty, String pictureUrl) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildTitleSection(title: "Docteur"),
          const SizedBox(height: 16),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  pictureUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 55,
                      width: 55,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.visibility_off, size: 30, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(specialty, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPatient(String fullName, String email, String motif) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildTitleSection(title: "Patient"),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              fullName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              email,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            color: Theme.of(context).colorScheme.outline.withAlpha(50),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Motif', style: TextStyle(color: Colors.grey.shade600)),
                Spacer(),
                Text(motif),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(String address, LatLng center, String pictureUrl) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildTitleSection(
              title: "Adresse du rendez-vous",
              trailing: InkWell(
                child: const Icon(Icons.directions_outlined),
                onTap: () {
                  // Handle navigation to maps
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              address,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            color: Theme.of(context).colorScheme.outline.withAlpha(50),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MapsViewer(
              zoom: 15,
              center: center,
              marker: CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                  pictureUrl,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTracking() {
    return SizedBox.shrink();
  }

  Widget _buildTitleSection({required String title, Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: trailing,
          )
      ],
    );
  }
}
