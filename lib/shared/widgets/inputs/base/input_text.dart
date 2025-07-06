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
  final bool? required;

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
    this.required = false,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  bool isValueEmpty = true;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    const inputBorderRadius = 12.0;
    const inputHeight = 16.0;

    return Material(
      elevation: 0.5,
      borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
      child: TextFormField(
        validator: (value) {
          if (widget.required == true && (value == null || value.trim().isEmpty)) {
            return 'Ce champ est requis';
          }
          if (widget.validator != null) {
            return widget.validator!(value);
          }
          return null;
        },
        keyboardType: _mapKeyboardType(widget.keyboardType),
        controller: widget.controller,
        inputFormatters: widget.mask,
        decoration: buildInputDecoration(
          context: context,
          label: widget.label,
          hintText: widget.placeholder,
          icon: widget.type == InputTextType.password
              ? (_obscureText ? Icons.visibility_off : Icons.visibility)
              : (!isValueEmpty ? Icons.clear : null),
          onTap: widget.type == InputTextType.password
              ? () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                }
              : () {
                  if (!isValueEmpty) {
                    widget.controller.clear();
                    setState(() {
                      isValueEmpty = true;
                    });
                  }
                },
        ),
        obscureText: widget.type == InputTextType.password ? _obscureText : false,
        onChanged: (value) {
          setState(() {
            isValueEmpty = value.isEmpty;
          });

          if (widget.onChange != null) {
            widget.onChange!(value);
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
