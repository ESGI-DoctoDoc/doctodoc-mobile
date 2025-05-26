import 'package:doctodoc_mobile/shared/widgets/cards/appointment_card.dart';
import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Widget> _incomingAppointments = [];
  List<Widget> _pastAppointments = [];
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
    _fetchInitialAppointments();
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
      backgroundColor: Color(0xFFEFEFEF),
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
              title: const Text('Rendez-vous'),
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
                    Tab(text: 'À venir'),
                    Tab(text: 'Passées'),
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
              return SliverList(
                delegate: SliverChildListDelegate(
                  _tabController.index == 0
                      ? _buildInComingAppointmentsTab()
                      : _buildPastAppointmentsTab(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInComingAppointmentsTab() {
    return [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ..._incomingAppointments,
            if (_isLoadingMore) const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> _buildPastAppointmentsTab() {
    return [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ..._pastAppointments,
            if (_isLoadingMore) const CircularProgressIndicator(),
          ],
        ),
      )
    ];
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoadingMore) {
      _loadMoreAppointments();
    }
  }

  void _fetchInitialAppointments() {
    setState(() {
      _incomingAppointments = List.generate(5, (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: AppointmentCard(),
      ));
      _pastAppointments = List.generate(5, (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: AppointmentCard(),
      ));
    });
  }

  void _loadMoreAppointments() async {
    setState(() {
      _isLoadingMore = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      final newItems = List.generate(3, (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: AppointmentCard(),
      ));
      if (_tabController.index == 0) {
        _incomingAppointments.addAll(newItems);
      } else {
        _pastAppointments.addAll(newItems);
      }
      _isLoadingMore = false;
    });
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
