import 'dart:async';

import 'package:doctodoc_mobile/shared/widgets/inputs/base/utils/input_decoration.dart';
import 'package:flutter/material.dart';

class InputDebounce extends StatefulWidget {
  final TextEditingController controller;
  final int debounceDuration;
  final String label;
  final String placeholder;
  final FocusNode? focusNode;

  const InputDebounce({super.key,
    required this.controller,
    this.debounceDuration = 300,
    required this.label,
    required this.placeholder,
    this.focusNode,
  });

  @override
  State<InputDebounce> createState() => _InputDebounceState();
}

class _InputDebounceState extends State<InputDebounce> {
  bool isValueEmpty = true;
  late final TextEditingController _debounceController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _debounceController = TextEditingController();

    _debounceController.addListener(() {
      final value = _debounceController.text;
      setState(() {
        isValueEmpty = value.isEmpty;
      });

      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: widget.debounceDuration), () {
        widget.controller.text = value;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _debounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.5,
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      child: TextFormField(
        controller: _debounceController,
        focusNode: widget.focusNode,
        decoration: buildInputDecoration(
          context: context,
          label: widget.label,
          hintText: widget.placeholder,
          icon: !isValueEmpty ? Icons.clear : null,
          onTap: () {
            if (!isValueEmpty) {
              _debounceController.clear();
              setState(() {
                isValueEmpty = true;
              });
            }
          },
        ),
      ),
    );
  }
}
