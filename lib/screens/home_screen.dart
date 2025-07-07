import 'package:doctodoc_mobile/blocs/appointment_blocs/display_appointments_bloc/display_appointments_bloc.dart';
import 'package:doctodoc_mobile/blocs/appointment_blocs/most_recent_upcoming_appointment_bloc/most_recent_upcoming_appointment_bloc.dart';
import 'package:doctodoc_mobile/models/appointment/appointment.dart';
import 'package:doctodoc_mobile/models/speciality.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:doctodoc_mobile/screens/doctors/doctor_search_screen.dart';
import 'package:doctodoc_mobile/screens/notifications/notifications_screen.dart';
import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/display_specialities_bloc/display_specialities_bloc.dart';
import '../blocs/user_blocs/user_bloc/user_bloc.dart';
import '../models/user.dart';
import '../services/data_sources/local_auth_data_source/shared_preferences_auth_data_source.dart';
import '../shared/widgets/cards/appointment_card.dart';
import '../shared/widgets/inputs/doctor_search_bar.dart';
import '../shared/widgets/list_tile/base/list_tile_base.dart';
import '../shared/widgets/list_tile/doctor_list_tile.dart';
import '../shared/widgets/texts/list_title.dart';
import 'doctors/doctor_detail_screen.dart';
import 'doctors/save_general_doctor.dart';
import 'introduction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final userBloc = context.read<UserBloc>();
    userBloc.add(OnUserLoadedBasicInfos());
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _searchFocusNode.unfocus();
        DoctorSearchScreen.navigateTo(context);
      }
    });
    _onLoadSpecialities();
    _onGetMostRecentUpComingAppointmentBloc();
    _onGetMostRecentPastAppointmentsBloc();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return switch (state) {
          UserLoading() || UserInitial() => _buildLoading(context),
          UserLoaded() => _buildSuccess(context, state.user),
          UserError() || UserState() => _buildError(),
        };
      },
    );
  }

  Widget _buildSuccess(BuildContext context, User user) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            floating: true,
            snap: true,
            pinned: true,
            centerTitle: true,
            automaticallyImplyLeading: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Text('Doctodoc'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_outlined),
                    onPressed: () {
                      NotificationsScreen.navigateTo(context);
                    },
                  ),
                ],
              ),
              background: Container(
                color: Color(0xFFEFEFEF),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // search bar
                    DoctorSearchBar(
                      focusNode: _searchFocusNode,
                      onSearch: (search) {
                        // Handle search action
                        print("Searching for: $search");
                      },
                    ),

                    // incoming appointments
                    const SizedBox(height: 10),
                    const ListTitle(title: "Rendez-vous à venir"),

                    BlocBuilder<MostRecentUpcomingAppointmentBloc,
                        MostRecentUpcomingAppointmentState>(builder: (context, state) {
                      return switch (state.status) {
                        MostRecentUpcomingAppointmentStatus.initial ||
                        MostRecentUpcomingAppointmentStatus.loading =>
                          const SizedBox.shrink(),
                        MostRecentUpcomingAppointmentStatus.success =>
                          _buildMostRecentUpComingAppointment(state.appointment),
                        MostRecentUpcomingAppointmentStatus.error =>
                          _buildErrorForMostRecentUpComing(),
                      };
                    }),

                    const SizedBox(height: 20),
                    const ListTitle(title: "Par spécialité"),
                    SizedBox(
                      height: 100,
                      child: BlocBuilder<DisplaySpecialitiesBloc, DisplaySpecialitiesState>(
                        builder: (context, state) {
                          return switch (state.status) {
                            DisplaySpecialitiesStatus.initial ||
                            DisplaySpecialitiesStatus.loading =>
                              const OnboardingLoading(),
                            DisplaySpecialitiesStatus.success =>
                              _buildSuccessForSpecialities(state.specialities),
                            DisplaySpecialitiesStatus.error => _buildErrorForSpecialities(),
                          };
                        },
                      ),
                    ),

                    ..._buildMyDoctorSection(),

                    const ListTitle(title: "Historique"),
                    BlocBuilder<DisplayAppointmentsBloc, DisplayAppointmentsState>(
                        builder: (context, state) {
                      return switch (state.status) {
                        DisplayAppointmentsStatus.initial ||
                        DisplayAppointmentsStatus.initialLoading ||
                        DisplayAppointmentsStatus.loading =>
                          const SizedBox.shrink(),
                        DisplayAppointmentsStatus.success =>
                          _buildMostRecentPastAppointments(state.appointments),
                        DisplayAppointmentsStatus.error => _buildErrorForMostRecentUpComing(),
                      };
                    }),
                    const SizedBox(height: 8),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMyDoctorSection() {
    final hasGeneralDoctor = false;
    //todo mélissa add
    if (hasGeneralDoctor) {
      return [
        const SizedBox(height: 20),
        ListTitle(
          title: "Mon médecin traitant",
          trailing: hasGeneralDoctor ? "Modifier" : null,
          onTrailingTap: () {
            if (hasGeneralDoctor) {
              SaveGeneralDoctor.navigateTo(context);
            }
          },
        ),
        /*return [
        const SizedBox(height: 20),
        const ListTitle(title: "Mon médecin traitant"),
        DoctorListTile(
          doctor: ,
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              DoctorDetailScreen.navigateTo(context, doctor.id);
            },
          ),
        ),
        const SizedBox(height: 20),
      ]; */
      ];
    } else {
      return [
        const SizedBox(height: 20),
        const ListTitle(title: "Mon médecin traitant"),
        ListTileBase(
          title: "Ajouter un médecin traitant",
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: const Icon(Icons.add),
          ),
          onTap: () {
            SaveGeneralDoctor.navigateTo(context);
          },
        ),
        const SizedBox(height: 20)
      ];
    }
  }

  Widget _buildMostRecentPastAppointments(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return ListTileBase(
        title: "Aucun rendez-vous récent.",
        leading: const Icon(Icons.history_outlined),
        onTap: () {},
      );
    } else {
      List<Appointment> firstThreeAppointments =
          appointments.length >= 3 ? appointments.sublist(0, 3) : appointments;

      List<Widget> appointmentWidgets = firstThreeAppointments
          .map((appointment) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: AppointmentCard(appointment: appointment),
              ))
          .toList();

      return Column(
        children: appointmentWidgets,
      );
    }
  }

  Widget _buildMostRecentUpComingAppointment(Appointment? appointment) {
    if (appointment == null) {
      return ListTileBase(
        title: "Aucun rendez-vous à venir.",
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.calendar_today_outlined),
        ),
        onTap: () {},
      );
    } else {
      return AppointmentCard(appointment: appointment);
    }
  }

  ListView _buildSuccessForSpecialities(List<Speciality> specialities) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: specialities.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            DoctorSearchScreen.navigateToWithFilters(context, {
              'speciality': specialities[index].name,
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.medical_services,
                    color: Colors.blue.shade800,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  specialities[index].name,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Impossible de récupérer les données utilisateur.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                  label: "Réessayer",
                  onTap: () {
                    // Retry logic can be added here
                    context.read<UserBloc>().add(OnUserLoadedBasicInfos());
                  }),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  _logoutUser(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Se déconnecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorForSpecialities() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  Widget _buildErrorForMostRecentUpComing() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  _onLoadSpecialities() {
    final specialityBloc = context.read<DisplaySpecialitiesBloc>();
    specialityBloc.add(OnGetSpecialities());
  }

  void _onGetMostRecentUpComingAppointmentBloc() {
    context.read<MostRecentUpcomingAppointmentBloc>().add(OnGet());
  }

  void _onGetMostRecentPastAppointmentsBloc() {
    context.read<DisplayAppointmentsBloc>().add(OnGetInitialPast());
  }

  void _logoutUser(BuildContext context) {
    final sharedPreferences = SharedPreferencesAuthDataSource();
    sharedPreferences.reset();
    IntroductionScreen.navigateTo(context);
  }
}
