import 'package:doctodoc_mobile/screens/appointment/appointment_screen.dart';
import 'package:doctodoc_mobile/screens/appointment/types/appointment_flow_address_data.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../appointment/types/appointment_flow_doctor_data.dart';

class DoctorDetailScreen extends StatefulWidget {
  static const String routeName = '/doctors/:doctorId';

  //todo mélissa convertir pour avoir le doctorId
  static void navigateTo(BuildContext context, String doctorId) {
    Navigator.pushNamed(context, routeName, arguments: {
      'doctorId': doctorId,
    });
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['doctorId'] is String) {
      return DoctorDetailScreen(doctorId: arguments['doctorId'] as String);
    }
    return const Center(child: Text('Doctor not found'));
  }

  final String doctorId;

  const DoctorDetailScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEFEFEF), // Light grey background
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Color(0xFFEFEFEF),
          body: Stack(
            children: [
              CustomScrollView(slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  expandedHeight: 200.0,
                  collapsedHeight: 100,
                  backgroundColor: Color(0xFFEFEFEF),
                  flexibleSpace: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final top = constraints.biggest.height;
                      final isCollapsed = top <= 190;
                      return FlexibleSpaceBar(
                        background: Container(
                          color: Color(0xFFEFEFEF),
                        ),
                        title: isCollapsed ? _buildCollapsedTitle() : _buildExpandedTitle(),
                      );
                    },
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  ..._buildBiography('TODO: bio'),
                  ..._buildAddress('TODO: address'),
                  ..._buildHours({
                    'Lundi': '08:30 - 18:00',
                    'Mardi': '08:30 - 18:00',
                    'Mercredi': '08:30 - 12:00',
                    'Jeudi': '08:30 - 18:00',
                    'Vendredi': '08:30 - 17:00',
                    'Samedi': '09:00 - 13:00',
                    'Dimanche': 'Fermé',
                  }), // TODO: horaires
                  ..._buildLanguages(['Français', 'Anglais', 'Espagnol']), // TODO: langues
                  ..._buildLegalInformation('TODO: RPPS'),
                  const SizedBox(height: 20),
                ]))
              ]),
              Positioned(
                top: 20,
                left: 5,
                child: SafeArea(
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left_outlined, size: 30, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 5,
                child: SafeArea(
                  child: IconButton(
                    icon: const Icon(Icons.calendar_month_outlined, size: 26, color: Colors.black),
                    onPressed: () {
                      //todo mélissa ajout les données ici
                      final doctor = AppointmentFlowDoctorData(
                        doctorId: widget.doctorId,
                        firstName: 'John',
                        lastName: 'Doe',
                        pictureUrl:
                            'https://www.shutterstock.com/image-photo/covid19-coronavirus-outbreak-healthcare-workers-260nw-1779353891.jpg',
                        address: const AppointmentFlowAddressData(
                          addressId: "addressId",
                          latitude: 23,
                          longitude: 23,
                        ),
                      );
                      AppointmentScreen.navigateTo(context, doctor);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection({required String title, Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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

  List<Widget> _buildBiography(String bio) {
    return [
      _buildTitleSection(title: 'Biographie'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          bio,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    ];
  }

  List<Widget> _buildAddress(String address) {
    return [
      const SizedBox(height: 8),
      _buildTitleSection(
        title: 'Adresse',
        trailing: TextButton(
          onPressed: () => _openMap(),
          child: Row(
            children: [
              Text(
                'Voir',
                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 4),
              Icon(Icons.map, size: 18, color: Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          address,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    ];
  }

  void _openMap() async {
    final Uri uri = Uri.parse(
      Uri.encodeFull(
          'https://www.google.com/maps/search/?api=1&query=123 Rue de la Santé, Paris, France'),
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch map';
    }
  }

  List<Widget> _buildHours(Map<String, String> hours) {
    final weekdays = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];

    final todayIndex = DateTime.now().weekday - 1; // 1 (Mon) -> 0, 7 (Sun) -> 6
    final reorderedKeys = [...weekdays.sublist(todayIndex), ...weekdays.sublist(0, todayIndex)];

    Widget buildRow(String day, String time) {
      return Row(
        children: [
          Expanded(
            child: Text(
              day,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Spacer(),
          Expanded(
            child: Text(
              time,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      );
    }

    return [
      const SizedBox(height: 8),
      _buildTitleSection(title: "Horaires"),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            for (final day in reorderedKeys) ...[
              buildRow(day, hours[day] ?? ''),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildLanguages(List<String> languages) {
    Widget buildRow((String, String) languages) {
      return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.language, size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  languages.$1,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          Spacer(),
          if (languages.$2.isNotEmpty)
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.language, size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    languages.$2,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return [
      const SizedBox(height: 8),
      _buildTitleSection(title: "Langues parlées"),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            for (int i = 0; i < languages.length; i += 2) ...[
              buildRow((languages[i], i + 1 < languages.length ? languages[i + 1] : '')),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildLegalInformation(String rpps) {
    return [
      const SizedBox(height: 8),
      _buildTitleSection(title: "Informations légales"),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Numéro RPPS : $rpps',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    ];
  }

  Widget _buildCollapsedTitle() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              const SizedBox(width: 50),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Adjust radius as needed
                  child: Image.network(
                    "https://www.shutterstock.com/image-photo/covid19-coronavirus-outbreak-healthcare-workers-260nw-1779353891.jpg",
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
                  Text(
                    'Dr. "firstname" ""',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    'Dentiste',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
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

  Widget _buildExpandedTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            "https://www.shutterstock.com/image-photo/covid19-coronavirus-outbreak-healthcare-workers-260nw-1779353891.jpg",
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Dr. John Doe',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          'Cardiologist',
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }
}
