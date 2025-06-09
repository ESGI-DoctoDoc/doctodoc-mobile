import 'package:doctodoc_mobile/blocs/display_specialities_bloc/display_specialities_bloc.dart';
import 'package:doctodoc_mobile/models/speciality.dart';
import 'package:doctodoc_mobile/screens/appointment/widgets/onboarding_loading.dart';
import 'package:doctodoc_mobile/shared/widgets/inputs/base/input_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecialityInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? required;

  const SpecialityInput({
    super.key,
    required this.controller,
    this.required,
  });

  @override
  State<SpecialityInput> createState() => _SpecialityInputState();
}

class _SpecialityInputState extends State<SpecialityInput> {
  @override
  void initState() {
    super.initState();

    final specialityBloc = context.read<DisplaySpecialitiesBloc>();
    specialityBloc.add(OnGetSpecialities());
  }

  final List<InputDropdownItem> specialityItems = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplaySpecialitiesBloc, DisplaySpecialitiesState>(
      builder: (context, state) {
        return switch (state.status) {
          DisplaySpecialitiesStatus.initial ||
          DisplaySpecialitiesStatus.loading =>
            const OnboardingLoading(),
          DisplaySpecialitiesStatus.success => _buildSuccess(state.specialities),
          DisplaySpecialitiesStatus.error => _buildError(),
        };
      },
    );
  }

  InputDropdown _buildSuccess(List<Speciality> specialities) {
    for (var speciality in specialities) {
      specialityItems.add(InputDropdownItem(
        label: speciality.name,
        value: speciality.name,
      ));
    }

    return InputDropdown(
      label: "Spécialité",
      placeholder: "Sélectionnez une spécialité",
      controller: widget.controller,
      items: specialityItems,
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text("Une erreur s'est produite."),
    );
  }
}
