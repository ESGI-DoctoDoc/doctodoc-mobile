import 'package:doctodoc_mobile/blocs/appointment_blocs/appointment_bloc/appointment_bloc.dart';
import 'package:doctodoc_mobile/blocs/appointment_blocs/appointment_detail_bloc/appointment_detail_bloc.dart';
import 'package:doctodoc_mobile/models/address.dart';
import 'package:doctodoc_mobile/models/appointment/appointment_detailed.dart';
import 'package:doctodoc_mobile/models/doctor/doctor.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:doctodoc_mobile/screens/doctors/doctor_detail_screen.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/error_button.dart';
import 'package:doctodoc_mobile/shared/widgets/maps/maps_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:latlong2/latlong.dart';

import '../../shared/widgets/modals/showCancelAppointmentReasonModal.dart';

class AppointmentDetailScreen extends StatefulWidget {
  static const String routeName = '/appointment/:appointmentId';

  static void navigateTo(BuildContext context, String appointmentId) {
    Navigator.pushNamed(context, routeName, arguments: {
      'appointmentId': appointmentId,
    });
  }

  static Widget routeBuilder(Map<String, dynamic> arguments) {
    if (arguments['appointmentId'] is String) {
      return AppointmentDetailScreen(appointmentId: arguments['appointmentId'] as String);
    } else {
      return const Center(child: Text('Invalid appointment ID'));
    }
  }

  final String appointmentId;

  const AppointmentDetailScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  void initState() {
    super.initState();
    _fetchAppointmentDetail();
    Jiffy.setLocale('fr-FR');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentDetailBloc, AppointmentDetailState>(
      builder: (context, state) {
        return Container(
          color: const Color(0xFFEFEFEF),
          child: SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor: const Color(0xFFEFEFEF),
              appBar: AppBar(
                title: const Text('Détails du rendez-vous'),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              body: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    color: Theme.of(context).primaryColor.withAlpha(50),
                    child: BlocBuilder<AppointmentDetailBloc, AppointmentDetailState>(
                      builder: (context, state) {
                        return switch (state) {
                          AppointmentDetailInitial() ||
                          AppointmentDetailLoading() =>
                            const OnboardingLoading(),
                          AppointmentDetailError() => _buildError(),
                          AppointmentDetailLoaded() =>
                            buildDateSection(state.appointment.date, state.appointment.start),
                        };
                        // return buildDateSection();
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BlocBuilder<AppointmentDetailBloc, AppointmentDetailState>(
                          builder: (context, state) {
                            return switch (state) {
                              AppointmentDetailInitial() ||
                              AppointmentDetailLoading() =>
                                const OnboardingLoading(),
                              AppointmentDetailError() => _buildError(),
                              AppointmentDetailLoaded() => _buildBody(state.appointment),
                            };
                            // return buildBody();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Column _buildBody(AppointmentDetailed appointment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDoctor(appointment.doctor),
        _buildPatient(appointment.patient, appointment.medicalConcern),
        _buildCareTracking(),
        _buildAddress(appointment.address, appointment.doctor.pictureUrl),
        const SizedBox(height: 16),
        if (DateTime.now().isBefore(DateTime.parse('${appointment.date} ${appointment.start}')))
          ErrorButton(
            label: "Annuler le rendez-vous",
            onTap: () async {
              final reason = await showReasonSelectionModal(context);
              if(reason != null) {
                _onCancelAppointment();
              }
            },
          ),
      ],
    );
  }

  void _onCancelAppointment() {
    context.read<AppointmentBloc>().add(OnCancelAppointment(id: widget.appointmentId));
    Navigator.of(context).pop();
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  Center buildDateSection(String date, String start) {
    return Center(
      child: Text(
        Jiffy.parse(date).format(pattern: "EEEE d MMMM yyyy") +
        ' - ' +
        Jiffy.parse(start, pattern: 'HH:mm').format(pattern: "HH:mm"),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDoctor(Doctor doctor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildTitleSection(title: "Docteur"),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              DoctorDetailScreen.navigateTo(context, doctor.id);
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    doctor.pictureUrl,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 55,
                        width: 55,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.visibility_off, size: 30, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${doctor.firstName} ${doctor.lastName}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(doctor.speciality, style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPatient(Patient patient, String motif) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildTitleSection(title: "Patient"),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${patient.firstName} ${patient.lastName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              patient.email,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            color: Theme.of(context).colorScheme.outline.withAlpha(50),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Motif', style: TextStyle(color: Colors.grey.shade600)),
                Spacer(),
                Text(motif),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(Address address, String pictureUrl) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildTitleSection(
              title: "Adresse du rendez-vous",
              trailing: InkWell(
                child: const Icon(Icons.directions_outlined),
                onTap: () {
                  // Handle navigation to maps
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              address.address,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            color: Theme.of(context).colorScheme.outline.withAlpha(50),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MapsViewer(
              zoom: 15,
              center: LatLng(address.latitude, address.longitude),
              marker: CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                  pictureUrl,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTracking() {
    return SizedBox.shrink();
  }

  Widget _buildTitleSection({required String title, Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
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

  void _fetchAppointmentDetail() {
    context.read<AppointmentDetailBloc>().add(OnGetAppointmentDetail(id: widget.appointmentId));
  }
}
