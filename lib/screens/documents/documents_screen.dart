import 'package:doctodoc_mobile/screens/appointments/care_tracking_tab.dart';
import 'package:doctodoc_mobile/screens/documents/documents_tab.dart';
import 'package:doctodoc_mobile/shared/widgets/banners/info_banner.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/care_tracking_list_tile.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/document_list_tile.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/show_document_upload_modal.dart';
import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollController.jumpTo(0);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget> _buildDocumentsTab() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBanner(title: "Vous seul avez accès à vos documents."),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              //todo group by year
              child: Text(
                '2025',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            DocumentListTile(title: "Vaccin contre la grippe"),
            const SizedBox(height: 10),
            DocumentListTile(title: "Vaccin contre la grippe"),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              //todo group by year
              child: Text(
                '2023',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            DocumentListTile(title: "Vaccin contre la grippe"),
            const SizedBox(height: 10),
            DocumentListTile(title: "Vaccin contre la grippe"),
            const SizedBox(height: 10),
            DocumentListTile(title: "Vaccin contre la grippe"),
          ],
        ),
      ),

      // End
      const SizedBox(height: 16),
    ];
  }

  List<Widget> _buildDossiersTab() {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBanner(title: "Vous seul pouvez autoriser l'accès à vos dossiers."),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              //todo group by year
              child: Text(
                '2025',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            CareTrackingListTile(
              title: "Médecin généraliste",
            ),
            const SizedBox(height: 10),
            CareTrackingListTile(
              title: "Médecin généraliste",
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              //todo group by year
              child: Text(
                '2024',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            CareTrackingListTile(
              title: "Médecin généraliste",
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              //todo group by year
              child: Text(
                '2023',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            CareTrackingListTile(
              title: "Médecin généraliste",
            ),
            const SizedBox(height: 10),
            CareTrackingListTile(
              title: "Médecin généraliste",
            ),
            const SizedBox(height: 10),
            CareTrackingListTile(
              title: "Médecin généraliste",
            ),
          ],
        ),
      ),

      // End
      const SizedBox(height: 16),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      floatingActionButton: _tabController.index == 1
          ? null
          : FloatingActionButton(
              onPressed: () => showDocumentUploadModal(context),
              child: const Icon(Icons.add),
            ),
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
              title: const Text('Documents'),
              background: Container(
                color: Color(0xFFEFEFEF),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _FixedTextHeader(
              child: Container(
                color: Color(0xFFEFEFEF),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Documents'),
                    Tab(text: 'Dossiers'),
                  ],
                  labelColor: Theme.of(context).primaryColor,
                  indicatorColor: Theme.of(context).primaryColor,
                  dividerHeight: 0.05,
                  onTap: (_) => setState(() {}),
                ),
              ),
              height: 48, // hauteur standard TabBar
            ),
          ),
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, child) {
              return _tabController.index == 0
                  ? DocumentsTab(scrollController: _scrollController)
                  : CareTrackingTab(scrollController: _scrollController);
            },
          ),
        ],
      ),
    );
  }
}

class _FixedTextHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _FixedTextHeader({required this.child, required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
