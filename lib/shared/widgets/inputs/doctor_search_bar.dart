import 'package:flutter/material.dart';

import 'base/input_debounce.dart';

class DoctorSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final FocusNode? focusNode;

  const DoctorSearchBar({
    super.key,
    required this.onSearch,
    this.focusNode,
  });

  @override
  State<DoctorSearchBar> createState() => _DoctorSearchBarState();
}

class _DoctorSearchBarState extends State<DoctorSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    widget.onSearch(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return InputDebounce(
      focusNode: widget.focusNode,
      controller: _controller,
      debounceDuration: 300,
      label: 'Rechercher un médecin',
      placeholder: "Nom d'un médecin",
    );
  }
}
