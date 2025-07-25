import 'package:doctodoc_mobile/models/doctor/doctor.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/doctor_list_tile.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/filter_search_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/doctor_blocs/display_doctor_bloc/display_doctor_bloc.dart';
import '../../shared/widgets/inputs/doctor_search_bar.dart';
import 'doctor_detail_screen.dart';

class DoctorSearchScreen extends StatefulWidget {
  static const String routeName = '/doctors/search';
  static const String routeName2 = '/doctors/search?speciality=:speciality';

  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, routeName);
  }

  static void navigateToWithFilters(
    BuildContext context,
    Map<String, String>? filters,
  ) {
    Navigator.pushNamed(context, routeName2, arguments: filters);
  }
  static Widget routeBuilder(Object? args) {
    if (args is Map<String, String>) {
      return DoctorSearchScreen(filters: args);
    }
    return const DoctorSearchScreen();
  }

  final Map<String, String>? filters;
  const DoctorSearchScreen({super.key, this.filters});

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchPageState();
}

class _DoctorSearchPageState extends State<DoctorSearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  String _name = '';
  Map<String, String>? _filters = {};

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _focusNode.requestFocus();
    });
    _scrollController.addListener(_onScroll);

    if(widget.filters != null) {
      _filters = widget.filters;
      _loadingInitialDoctorSearch();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFEFEF),
      child: Scaffold(
        backgroundColor: const Color(0xFFEFEFEF),
        appBar: AppBar(
          title: const Text("Rechercher un médecin"),
          backgroundColor: const Color(0xFFEFEFEF),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DoctorSearchBar(
                focusNode: _focusNode,
                onSearch: (value) {
                  _name = value;
                  _loadingInitialDoctorSearch();
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Résultats',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      applyFilters(context);
                    },
                    icon: const Icon(Icons.filter_list),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    return false;
                  },
                  child: BlocBuilder<DisplayDoctorBloc, DisplayDoctorState>(
                    builder: (context, state) {
                      return switch (state.status) {
                        DisplayDoctorStatus.initial ||
                        DisplayDoctorStatus.initialLoading =>
                          _buildInitial(),
                        DisplayDoctorStatus.loading ||
                        DisplayDoctorStatus.success =>
                          _buildSuccess(state.doctors, state.isLoadingMore),
                        DisplayDoctorStatus.error => _buildError(),
                      };
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
        _isLoadingMore) {
      _loadNextDoctorSearch();
    }
  }

  Widget _buildSuccess(List<Doctor> doctors, bool isLoadingMore) {
    _isLoadingMore = isLoadingMore;

    if (doctors.isEmpty && (_name.isEmpty || _name == '')) {
      return const Center(
        child: Text("Tapez pour rechercher un médecin"),
      );
    } else if (doctors.isEmpty) {
      return const Center(
        child: Text("Aucun médecin trouvé pour cette recherche."),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: isLoadingMore ? doctors.length + 1 : doctors.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8.0),
      itemBuilder: (context, index) {
        if (index >= doctors.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return DoctorListTile(
          doctor: doctors[index],
          onTap: () => DoctorDetailScreen.navigateTo(context, doctors[index].id),
        );
      },
    );
  }

  Widget _buildInitial() {
    return const Center(
      child: Text("Tapez pour rechercher un médecin"),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }

  void applyFilters(BuildContext context) async {
    final Map<String, String>? filters = await showFilterSearchModal(context, _filters);
    _filters = filters;
    _loadingInitialDoctorSearch();
  }

  void _loadingInitialDoctorSearch() {
    final displayDoctor = context.read<DisplayDoctorBloc>();
    displayDoctor.add(OnGetInitialSearchDoctor(
      name: _name,
      speciality: _filters?['speciality'] ?? '',
      languages: _filters?['languages'] ?? '',
    ));
  }

  void _loadNextDoctorSearch() {
    final displayDoctor = context.read<DisplayDoctorBloc>();
    displayDoctor.add(OnGetNextSearchDoctor(
      name: _name,
      speciality: _filters?['speciality'] ?? '',
      languages: _filters?['languages'] ?? '',
    ));
  }
}
