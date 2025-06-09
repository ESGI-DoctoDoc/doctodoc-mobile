import 'package:doctodoc_mobile/shared/widgets/buttons/primary_button.dart';
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

class InputMultiDropdown extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final List<InputDropdownItem> items;
  final Function(String?)? validator;

  const InputMultiDropdown({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    required this.items,
    this.validator,
  });

  @override
  State<InputMultiDropdown> createState() => _InputMultiDropdownState();
}

class _InputMultiDropdownState extends State<InputMultiDropdown> {
  final Set<InputDropdownItem> _selectedItems = {};
  late final TextEditingController _displayController = TextEditingController();

  void _openSelectDialog() async {
    final result = await showModalBottomSheet<Set<InputDropdownItem>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final tempSelectedItems = Set<InputDropdownItem>.from(_selectedItems);
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: widget.items.map((item) {
                                final selected = tempSelectedItems.contains(item);
                                return CheckboxListTile(
                                  value: selected,
                                  title: Text(item.label),
                                  secondary: item.icon != null ? Icon(item.icon) : null,
                                  onChanged: (_) {
                                    setModalState(() {
                                      if (selected) {
                                        tempSelectedItems.remove(item);
                                      } else {
                                        tempSelectedItems.add(item);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: PrimaryButton(
                            label: "Valider",
                            onTap: () {
                              Navigator.of(context).pop(tempSelectedItems);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedItems
          ..clear()
          ..addAll(result);
        _displayController.text = _selectedItems.map((e) => e.label).join(", ");
        widget.controller.text = _selectedItems.map((e) => e.value).join(",");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const inputBorderRadius = 12.0;

    return Material(
      elevation: 0.5,
      borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
      child: GestureDetector(
        onTap: _openSelectDialog,
        child: AbsorbPointer(
          child: TextField(
            controller: _displayController,
            readOnly: true,
            decoration: buildInputDecoration(
              context: context,
              label: widget.label,
              hintText: widget.placeholder,
              icon: Icons.arrow_drop_down,
              onTap: () {
                widget.controller.clear();
                _selectedItems.clear();
                _displayController.clear();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }
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
  late final TextEditingController _displayController = TextEditingController();

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
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
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
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        widget.controller.text = selected.value;
        _displayController.text = selected.label;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const inputBorderRadius = 12.0;

    return Material(
      elevation: 0.5,
      borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
      child: GestureDetector(
        onTap: _openSelectDialog,
        child: AbsorbPointer(
          child: TextField(
            controller: _displayController,
            readOnly: true,
            decoration: buildInputDecoration(
              context: context,
              label: widget.label,
              hintText: widget.placeholder,
              icon: Icons.arrow_drop_down,
              onTap: () {
                widget.controller.clear();
                _displayController.clear();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }
}
