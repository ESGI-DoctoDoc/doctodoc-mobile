import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/appointment_blocs/display_appointments_bloc/display_appointments_bloc.dart';
import '../../services/repositories/appointment_repository/appointment_repository.dart';
import 'appointments_in_coming.dart';
import 'appointments_past.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> with TickerProviderStateMixin {
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
                    Tab(text: 'Passés'),
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
                  ? BlocProvider(
                      create: (context) => DisplayAppointmentsBloc(
                          appointmentRepository: context.read<AppointmentRepository>()),
                      child: AppointmentInComing(scrollController: _scrollController),
                    )
                  : BlocProvider(
                      create: (context) => DisplayAppointmentsBloc(
                          appointmentRepository: context.read<AppointmentRepository>()),
                      child: AppointmentPast(scrollController: _scrollController),
                    );
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
