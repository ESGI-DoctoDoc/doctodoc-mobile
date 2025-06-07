import 'package:doctodoc_mobile/shared/widgets/cards/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/appointment_blocs/display_appointment_bloc/display_appointment_bloc.dart';
import '../../models/appointment.dart';
import '../appointment/widgets/onboarding_loading.dart';

class AppointmentPast extends StatefulWidget {
  final ScrollController scrollController;

  const AppointmentPast({super.key, required this.scrollController});

  @override
  State<AppointmentPast> createState() => _AppointmentPastState();
}

class _AppointmentPastState extends State<AppointmentPast> {
  bool _isLoadingMore = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    _fetchInitialAppointments();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocBuilder<DisplayAppointmentBloc, DisplayAppointmentState>(
              builder: (context, state) {
                return switch (state.status) {
                  DisplayAppointmentStatus.initial ||
                  DisplayAppointmentStatus.initialLoading =>
                  const OnboardingLoading(),
                  DisplayAppointmentStatus.success ||
                  DisplayAppointmentStatus.loading =>
                      _buildSuccess(state.appointments, state.isLoadingMore),
                  DisplayAppointmentStatus.error => _buildError(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(List<Appointment> appointments, bool isLoadingMore) {
    List<Widget> appointmentWidgets = appointments.map((appointment) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: AppointmentCard(appointment: appointment),
      );
    }).toList();

    _isLoadingMore = isLoadingMore;

    return Column(
      children: [
        ...appointmentWidgets,
        if (isLoadingMore) const CircularProgressIndicator() else const Text('Rien à charger'),
      ],
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  void _onScroll() {
    if (widget.scrollController.position.pixels >= widget.scrollController.position.maxScrollExtent &&
        _isLoadingMore) {
      _fetchNextAppointments();
    }
  }

  void _fetchInitialAppointments() {
    final bloc = context.read<DisplayAppointmentBloc>();
    bloc.add(OnGetInitialPast());
  }

  void _fetchNextAppointments() {
    final bloc = context.read<DisplayAppointmentBloc>();
    bloc.add(OnGetNextPart());
  }
}