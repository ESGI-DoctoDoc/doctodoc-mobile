import 'package:doctodoc_mobile/shared/widgets/inputs/base/utils/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputTextType {
  text,
  password,
  phone,
}

enum InputKeyboardType {
  text,
  email,
  numeric,
}

class InputText extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final InputTextType? type;
  final Function(String?)? validator;
  final List<TextInputFormatter>? mask;
  final InputKeyboardType? keyboardType;
  final Function? onChange;

  const InputText({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.type = InputTextType.text,
    this.keyboardType = InputKeyboardType.text,
    this.validator,
    this.mask,
    this.onChange,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    const inputBorderRadius = 12.0;
    const inputHeight = 16.0;

    return Material(
      elevation: 0.5,
      borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
      child: TextFormField(
        validator: widget.validator != null
            ? (value) => widget.validator!(value)
            : null,
        keyboardType: _mapKeyboardType(widget.keyboardType),
        controller: widget.controller,
        inputFormatters: widget.mask,
        decoration: buildInputDecoration(
            context: context,
            label: widget.label,
            hintText: widget.placeholder,
            icon: Icons.close),
        obscureText: widget.type == InputTextType.password,
        onChanged: (value) {
          if(widget.onChange != null) {
            widget.onChange!();
          }
        },
      ),
    );
  }

  TextInputType _mapKeyboardType(InputKeyboardType? type) {
    switch (type) {
      case InputKeyboardType.email:
        return TextInputType.emailAddress;
      case InputKeyboardType.numeric:
        return TextInputType.number;
      case InputKeyboardType.text:
      default:
        return TextInputType.text;
    }
  }
}
