import 'package:doctodoc_mobile/shared/widgets/banners/info_banner.dart';
import 'package:flutter/material.dart';

class Document {
  final String id;
  final String name;
  final String type;
  final bool isShared;

  Document({
    required this.id,
    required this.name,
    required this.type,
    required this.isShared,
  });
}

class CareTrackingPermissionsScreen extends StatefulWidget {
  static const String routeName = '/appointment/:appointmentId/permissions';

  static void navigateTo(BuildContext context, String appointmentId) {
    Navigator.pushNamed(context, routeName, arguments: {
      'appointmentId': appointmentId,
    });
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['appointmentId'] is String) {
      return CareTrackingPermissionsScreen(appointmentId: arguments['appointmentId'] as String);
    } else {
      return const Center(child: Text('Invalid appointment ID'));
    }
  }

  final String appointmentId;

  const CareTrackingPermissionsScreen({super.key, required this.appointmentId});

  @override
  State<CareTrackingPermissionsScreen> createState() => _CareTrackingPermissionsScreenState();
}

class _CareTrackingPermissionsScreenState extends State<CareTrackingPermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFEFEF),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFEFEFEF),
          appBar: AppBar(
            title: const Text('Permissions'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InfoBanner(title: "Tant que vous n'avez pas autorisé le partage de vos documents, ils ne seront pas accessibles aux médecins."),
                  _buildHeader(),
                  ..._buildFiles([
                    Document(id: '1', name: 'Document 1', type: 'PDF', isShared: false),
                    Document(id: '2', name: 'Document 2', type: 'Image', isShared: true),
                    Document(id: '3', name: 'Document 3', type: 'Text', isShared: false),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Autoriser chaque fichier à être partagé avec les professionnels de santé.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFiles(List<Document> documents) {
    // Widget buildFileTile(Document doc) {
    //   return DocumentListTile(
    //     title: doc.name,
    //     trailing: Transform.scale(
    //       scale: 0.75,
    //       child: Switch(
    //         value: doc.isShared,
    //         onChanged: (bool newValue) {
    //           setState(() {
    //             // todo mélissa appel
    //             final isShared = !doc.isShared;
    //             print("new isShared state: $isShared");
    //           });
    //         },
    //       ),
    //     ),
    //   );
    // }

    return documents.map((doc) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        // child: buildFileTile(doc), // todo j'ai commenté
      );
    }).toList();
  }
}
