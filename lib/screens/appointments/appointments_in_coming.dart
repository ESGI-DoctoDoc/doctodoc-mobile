import 'package:doctodoc_mobile/models/appointment/appointment.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:doctodoc_mobile/shared/widgets/cards/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/appointment_blocs/display_appointments_bloc/display_appointments_bloc.dart';

class AppointmentInComing extends StatefulWidget {
  final ScrollController scrollController;

  const AppointmentInComing({super.key, required this.scrollController});

  @override
  State<AppointmentInComing> createState() => _AppointmentInComingState();
}

class _AppointmentInComingState extends State<AppointmentInComing> {
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
            child: BlocBuilder<DisplayAppointmentsBloc, DisplayAppointmentsState>(
              builder: (context, state) {
                return switch (state.status) {
                  DisplayAppointmentsStatus.initial ||
                  DisplayAppointmentsStatus.initialLoading =>
                    const OnboardingLoading(),
                  DisplayAppointmentsStatus.success ||
                  DisplayAppointmentsStatus.loading =>
                    _buildSuccess(state.appointments, state.isLoadingMore),
                  DisplayAppointmentsStatus.error => _buildError(),
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

    if(appointmentWidgets.isEmpty) {
      return const Center(
        child: Text("Pas de rendez-vous à venir."),
      );
    }
    _isLoadingMore = isLoadingMore;

    return Column(
      children: [
        ...appointmentWidgets,
        if (isLoadingMore) const CircularProgressIndicator() else const SizedBox.shrink(),
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
    if(mounted) {
      final bloc = context.read<DisplayAppointmentsBloc>();
      bloc.add(OnGetInitialUpComing());
    }
  }

  void _fetchNextAppointments() {
    if(mounted) {
      final bloc = context.read<DisplayAppointmentsBloc>();
      bloc.add(OnGetNextUpComing());
    }
  }
}