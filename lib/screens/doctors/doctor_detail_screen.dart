import 'package:doctodoc_mobile/screens/appointment/widgets/appointment_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
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
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final top = constraints.biggest.height;
                  final isCollapsed = top <= 190;
                  return FlexibleSpaceBar(
                    title: isCollapsed ? _buildCollapsedTitle() : _buildExpandedTitle(),
                  );
                },
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              ..._buildBiography(),
              ..._buildAddress(),
              ..._buildHours(),
              ..._buildLanguages(),
              ..._buildLegalInformation(),
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
                onPressed: () {},
              ),
            ),
          ),
        ],
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

  List<Widget> _buildBiography() {
    return [
      _buildTitleSection(title: 'Biographie'),
      const Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Dr. John Doe est un cardiologue renommé avec plus de 10 ans d\'expérience dans le domaine. Il est spécialisé dans le traitement des maladies cardiaques et offre des soins personnalisés à ses patients.',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    ];
  }

  List<Widget> _buildAddress() {
    return [
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
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          '123 Rue de la Santé, Paris, France',
          style: TextStyle(fontSize: 14, color: Colors.black87),
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

  List<Widget> _buildHours() {
    return [];
  }

  List<Widget> _buildLanguages() {
    final languages = ['Français', 'Anglais', 'Espagnol', 'Allemand'];

    return [
      _buildTitleSection(title: "Langues parlées"),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 4,
          children: languages.map((lang) {
            return Row(
              children: [
                const Icon(Icons.language, size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  lang,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    ];
  }

  List<Widget> _buildLegalInformation() {
    return [];
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
