import 'package:doctodoc_mobile/blocs/appointment_blocs/display_appointment_bloc/display_appointment_bloc.dart';
import 'package:doctodoc_mobile/models/appointment.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:doctodoc_mobile/shared/widgets/cards/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Widget> _pastAppointments = [];
  bool _isLoadingMore = true;
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
      BlocBuilder<DisplayAppointmentBloc, DisplayAppointmentState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocBuilder<DisplayAppointmentBloc, DisplayAppointmentState>(
              builder: (context, state) {
                return switch (state.status) {
                  DisplayAppointmentStatus.initial ||
                  DisplayAppointmentStatus.initialLoading =>
                    const OnboardingLoading(), // todo : Corentin is ok ?
                  DisplayAppointmentStatus.success ||
                  DisplayAppointmentStatus.loading =>
                    _buildSuccess(state.appointments, state.isLoadingMore),
                  DisplayAppointmentStatus.error => _buildError(),
                };
              },
            ),
          );
        },
      )
    ];
  }

  Widget _buildSuccess(List<Appointment> appointments, bool isLoadingMore) {
    List<Widget> appointmentsUpComings = [];

    for (var appointment in appointments) {
      appointmentsUpComings.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: AppointmentCard(
            appointment: appointment,
          ),
        ),
      );
    }

    _isLoadingMore = isLoadingMore;
    Widget lastOne = isLoadingMore ? const CircularProgressIndicator() : const Text('nothing');

    return Column(
      children: [
        ...appointmentsUpComings,
        lastOne,
      ],
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  List<Widget> _buildPastAppointmentsTab() {
    return [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ..._pastAppointments,
            // if (_isLoadingMore) const CircularProgressIndicator(),
          ],
        ),
      )
    ];
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        _isLoadingMore) {
      _fetchInitialAppointments();
    }
  }

  void _fetchInitialAppointments() {
    final displayAppointmentBloc = context.read<DisplayAppointmentBloc>();
    displayAppointmentBloc.add(OnGetAllUpComing());
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
