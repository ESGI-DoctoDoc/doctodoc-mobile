import 'package:doctodoc_mobile/shared/widgets/inputs/language_input.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/speciality_input.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/doctor_list_tile.dart';
import 'package:doctodoc_mobile/shared/widgets/modals/filter_search_modal.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/inputs/doctor_search_bar.dart';

class DoctorSearchScreen extends StatefulWidget {
  static const String routeName = '/doctors/search';

  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, routeName);
  }

  const DoctorSearchScreen({super.key});

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchPageState();
}

class _DoctorSearchPageState extends State<DoctorSearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _focusNode.requestFocus();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoadingMore) {
        setState(() {
          _isLoadingMore = true;
        });
        // TODO mélissa: charger plus de résultats ici
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _isLoadingMore = false;
          });
        });
      }
    });
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
                  //todo mélissa tu as la valeur qui possède déjà un debounce
                  print("Recherche: $value");
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
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: 10 + (_isLoadingMore ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      if (index == 10) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DoctorListTile(
                        onTap: () {},
                      );
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

  void applyFilters(BuildContext context) async {
    final Map<String, String>? filters = await showFilterSearchModal(context);
    //todo mélissa tu as les filtres ici
    print(filters);
  }
}
