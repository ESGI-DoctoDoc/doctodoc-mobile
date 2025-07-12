import 'package:doctodoc_mobile/blocs/appointment_blocs/appointment_flow_bloc/appointment_flow_bloc.dart';
import 'package:doctodoc_mobile/blocs/doctor_blocs/doctor_detail_bloc/doctor_detail_bloc.dart';
import 'package:doctodoc_mobile/blocs/report_doctor_bloc/report_doctor_bloc.dart';
import 'package:doctodoc_mobile/models/doctor/doctor_detailed.dart';
import 'package:doctodoc_mobile/screens/appointment/appointment_screen.dart';
import 'package:doctodoc_mobile/screens/appointment/types/appointment_flow_address_data.dart';
import 'package:doctodoc_mobile/shared/utils/show_error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/modals/showReportDoctorModal.dart';
import '../appointment/types/appointment_flow_doctor_data.dart';

class DoctorDetailScreen extends StatefulWidget {
  static const String routeName = '/doctors/:doctorId';

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
  void initState() {
    super.initState();
    _onLoadDoctorDetail();
    _onLoadMedicalConcern();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorDetailBloc, DoctorDetailState>(
      builder: (context, state) {
        return switch (state) {
          DoctorDetailInitial() || DoctorDetailLoading() => const SizedBox.shrink(),
          DoctorDetailError() => _buildError(),
          DoctorDetailLoaded() => _buildSuccess(state.doctor),
        };
      },
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  Container _buildSuccess(DoctorDetailed doctorDetailed) {
    return Container(
      color: Color(0xFFEFEFEF), // Light grey background
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Color(0xFFEFEFEF),
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
                  backgroundColor: Color(0xFFEFEFEF),
                  flexibleSpace: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final top = constraints.biggest.height;
                      final isCollapsed = top <= 190;
                      return FlexibleSpaceBar(
                        centerTitle: true,
                        background: Container(
                          color: Color(0xFFEFEFEF),
                        ),
                        title: isCollapsed
                            ? _buildCollapsedTitle(doctorDetailed)
                            : _buildExpandedTitle(doctorDetailed),
                      );
                    },
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  ..._buildBiography(doctorDetailed.biography),
                  ..._buildAddress(doctorDetailed.address.address),
                  ..._buildHours(OpeningHours.openingHoursListToMap(doctorDetailed.openingHours)),
                  ..._buildLanguages(doctorDetailed.languages),
                  ..._buildLegalInformation(doctorDetailed.rpps),
                  const SizedBox(height: 20),
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
                    icon: const Icon(Icons.report_outlined, size: 26, color: Colors.black),
                    onPressed: () async {
                      final reason = await showReportDoctorModal(context);
                      if (reason != null) {
                        _reportDoctor(reason);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BlocBuilder<AppointmentFlowBloc, AppointmentFlowState>(
            builder: (context, state) {
              return switch (state.getMedicalConcernsStatus) {
                GetMedicalConcernsStatus.initial ||
                GetMedicalConcernsStatus.loading =>
                  _buildLoadingWhenGetMedicalConcern(),
                GetMedicalConcernsStatus.success => state.medicalConcerns.isNotEmpty
                    ? _buildWhenHaveMedicalConcern(doctorDetailed)
                    : const SizedBox.shrink(),
                GetMedicalConcernsStatus.error => _buildErrorWhenGetMedicalConcern(),
              };
            },
          ),
        ),
      ),
    );
  }

  void _reportDoctor(String reason) {
    context.read<ReportDoctorBloc>().add(OnReportDoctor(
          doctorId: widget.doctorId,
          explanation: reason,
        ));
  }

  Widget _buildErrorWhenGetMedicalConcern() {
    return IconButton(
      icon: const Icon(Icons.error_outline, size: 26, color: Colors.red),
      onPressed: () {},
    );
  }

  Widget _buildLoadingWhenGetMedicalConcern() {
    return IconButton(
      icon: const Icon(Icons.downloading, size: 26, color: Colors.yellow),
      onPressed: () {},
    );
  }

  Widget _buildWhenHaveMedicalConcern(DoctorDetailed doctorDetailed) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PrimaryButton(
        label: 'Prendre rendez-vous',
        onTap: () {
          final doctor = AppointmentFlowDoctorData(
            doctorId: widget.doctorId,
            firstName: doctorDetailed.basicInformation.firstName,
            lastName: doctorDetailed.basicInformation.lastName,
            pictureUrl: doctorDetailed.basicInformation.pictureUrl,
            address: AppointmentFlowAddressData(
              latitude: doctorDetailed.address.latitude,
              longitude: doctorDetailed.address.longitude,
            ),
          );
          AppointmentScreen.navigateTo(context, doctor);
        },
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

  List<Widget> _buildBiography(String bio) {
    return [
      _buildTitleSection(title: 'Biographie'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          bio,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    ];
  }

  List<Widget> _buildAddress(String address) {
    return [
      const SizedBox(height: 8),
      _buildTitleSection(
        title: 'Adresse',
        trailing: TextButton(
          onPressed: () => _openMap(address),
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          address,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    ];
  }

  void _openMap(String address) async {
    final Uri uri =
        Uri.parse(Uri.encodeFull('https://www.google.com/maps/search/?api=1&query=$address'));

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showErrorSnackbar(context, "Impossible d'ouvrir la carte.");
    }
  }

  List<Widget> _buildHours(Map<String, String> hours) {
    final weekdays = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];

    final todayIndex = DateTime.now().weekday - 1; // 1 (Mon) -> 0, 7 (Sun) -> 6
    final reorderedKeys = [...weekdays.sublist(todayIndex), ...weekdays.sublist(0, todayIndex)];

    Widget buildRow(String day, String time) {
      return Row(
        children: [
          Expanded(
            child: Text(
              day,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Spacer(),
          Expanded(
            child: Text(
              time,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      );
    }

    return [
      const SizedBox(height: 8),
      _buildTitleSection(title: "Horaires"),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            for (final day in reorderedKeys) ...[
              buildRow(day, hours[day] ?? ''),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildLanguages(List<String> languages) {
    Widget buildRow((String, String) languages) {
      return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.language, size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  _translateLanguage(languages.$1),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          Spacer(),
          if (languages.$2.isNotEmpty)
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.language, size: 16, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    _translateLanguage(languages.$2),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return [
      const SizedBox(height: 8),
      _buildTitleSection(title: "Langues parlées"),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            for (int i = 0; i < languages.length; i += 2) ...[
              buildRow((languages[i], i + 1 < languages.length ? languages[i + 1] : '')),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    ];
  }

  String _translateLanguage(String lang) {
    const translations = {
      'French': 'Français',
      'English': 'Anglais',
      'Spanish': 'Espagnol',
      'German': 'Allemand',
      'Italian': 'Italien',
      'Chinese': 'Chinois',
      'Arabic': 'Arabe',
      'Portuguese': 'Portugais',
      'Russian': 'Russe',
      'Japanese': 'Japonais',
      'Korean': 'Coréen',
    };
    return translations[lang] ?? lang;
  }

  List<Widget> _buildLegalInformation(String rpps) {
    return [
      const SizedBox(height: 8),
      _buildTitleSection(title: "Informations légales"),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Numéro RPPS : $rpps',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    ];
  }

  Widget _buildCollapsedTitle(DoctorDetailed doctor) {
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
                    doctor.basicInformation.pictureUrl,
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
                    'Dr. ${doctor.basicInformation.firstName}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    doctor.basicInformation.speciality,
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

  Widget _buildExpandedTitle(DoctorDetailed doctorDetailed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            doctorDetailed.basicInformation.pictureUrl,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Dr. ${doctorDetailed.basicInformation.firstName} ${doctorDetailed.basicInformation.lastName}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          doctorDetailed.basicInformation.speciality,
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }

  _onLoadDoctorDetail() {
    final doctorDetailedBloc = context.read<DoctorDetailBloc>();
    doctorDetailedBloc.add(OnGetDoctorDetail(id: widget.doctorId));
  }

  _onLoadMedicalConcern() {
    final appointmentFlowBloc = context.read<AppointmentFlowBloc>();
    appointmentFlowBloc.add(GetMedicalConcerns(doctorId: widget.doctorId));
  }
}
