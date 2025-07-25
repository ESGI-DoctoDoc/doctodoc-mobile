import 'package:doctodoc_mobile/screens/appointments/care_tracking_tab.dart';
import 'package:doctodoc_mobile/screens/documents/documents_tab.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      floatingActionButton: _tabController.index == 1
          ? null
          : FloatingActionButton(
              onPressed: () => showDocumentUploadModal(context),
              child: const Icon(Icons.add),
            ),
      body: CustomScrollView(
        controller: _scrollController,
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
              title: const Text('Documents'),
              background: Container(
                color: const Color(0xFFEFEFEF),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _FixedTextHeader(
              child: Container(
                color: const Color(0xFFEFEFEF),
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
