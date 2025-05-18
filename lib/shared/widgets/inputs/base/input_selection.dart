import 'package:flutter/material.dart';

class InputSelectionItem {
  final String label;
  final String value;
  final IconData? icon;

  const InputSelectionItem({
    required this.label,
    required this.value,
    this.icon,
  });
}

class InputSelection extends StatefulWidget {
  final TextEditingController controller;
  final List<InputSelectionItem> items;
  final Function(InputSelectionItem item) onChange;
  final String? Function(String?)? validator;
  final bool required;

  const InputSelection({
    super.key,
    required this.controller,
    required this.items,
    required this.onChange,
    this.validator,
    this.required = false,
  });

  @override
  State<InputSelection> createState() => _InputSelectionState();
}

class _InputSelectionState extends State<InputSelection> {
  @override
  Widget build(BuildContext context) {
    const inputBorderRadius = 12.0;

    return FormField<String>(
      validator: (value) {
        if (widget.required && (value == null || value.trim().isEmpty)) {
          return 'Ce champ est requis';
        }
        if (widget.validator != null) {
          return widget.validator!(value);
        }
        return null;
      },
      initialValue: widget.controller.text,
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 0.5,
              borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
              child: _buildItems(context, widget.items, formFieldState),
            ),
            if (formFieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  formFieldState.errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildItems(BuildContext context, List<InputSelectionItem> items, FormFieldState<String> formFieldState) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Theme.of(context).dividerColor.withAlpha(77)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.items.length * 2 - 1,
          (index) {
            if (index.isEven) {
              final item = widget.items[index ~/ 2];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                title: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: item.icon != null ? Icon(item.icon) : null,
                trailing: widget.controller.text == item.value
                    ? Icon(Icons.radio_button_checked, color: Theme.of(context).primaryColor)
                    : Icon(Icons.radio_button_off, color: Theme.of(context).dividerColor),
                onTap: () {
                  setState(() {
                    widget.controller.text = item.value;
                  });
                  formFieldState.didChange(item.value);
                  widget.onChange(item);
                },
              );
            } else {
              return Divider(color: Theme.of(context).dividerColor.withAlpha(77), height: 1);
            }
          },
        ),
      ),
    );
  }

  bool _isSelected(InputSelectionItem item) {
    return widget.controller.text == item.value;
  }
}
