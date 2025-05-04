import 'package:doctodoc_mobile/shared/widgets/inputs/base/utils/input_decoration.dart';
import 'package:flutter/material.dart';

class InputDropdownItem {
  final String label;
  final String value;
  final IconData? icon;

  const InputDropdownItem({
    required this.label,
    required this.value,
    this.icon,
  });
}

class InputDropdown extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final List<InputDropdownItem> items;
  final Function(String?)? validator;

  const InputDropdown({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    required this.items,
    this.validator,
  });

  @override
  State<InputDropdown> createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdown> {
  void _openSelectDialog() async {
    final selected = await showModalBottomSheet<InputDropdownItem>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.items.map((item) {
              return ListTile(
                title: Text(item.label),
                leading: Icon(item.icon),
                onTap: () => Navigator.of(context).pop(item),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        widget.controller.text = selected.label;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const inputBorderRadius = 12.0;
    const inputHeight = 16.0;

    return Material(
      elevation: 0.5,
      borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
      child: GestureDetector(
        onTap: _openSelectDialog,
        child: AbsorbPointer(
          child: TextField(
            controller: widget.controller,
            readOnly: true,
            decoration: buildInputDecoration(
              context: context,
              label: widget.label,
              hintText: widget.placeholder,
              icon: Icons.arrow_drop_down
            ),
          ),
        ),
      ),
    );
  }
}
