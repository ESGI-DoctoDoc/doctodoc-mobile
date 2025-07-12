import 'package:flutter/material.dart';

class InputChoiceItem {
  final String label;
  final String value;
  final bool disabled;

  const InputChoiceItem({
    required this.label,
    required this.value,
    this.disabled = false,
  });
}

class InputChoice extends StatefulWidget {
  final TextEditingController controller;
  final List<InputChoiceItem> items;
  final Function(InputChoiceItem item) onChange;
  final int maxPerRow;
  final String? Function(String?)? validator;
  final bool? required;

  const InputChoice({
    super.key,
    required this.controller,
    required this.items,
    required this.onChange,
    this.maxPerRow = 3,
    this.validator,
    this.required = false,
  });

  @override
  State<InputChoice> createState() => _InputChoiceState();
}

class _InputChoiceState extends State<InputChoice> {
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) {
        if (widget.required == true && (value == null || value.trim().isEmpty)) {
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
            Column(
              children: List.generate(
                (widget.items.length / widget.maxPerRow).ceil(),
                (rowIndex) {
                  final startIndex = rowIndex * widget.maxPerRow;
                  final endIndex = (startIndex + widget.maxPerRow).clamp(0, widget.items.length);
                  final rowItems = widget.items.sublist(startIndex, endIndex);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: List.generate(
                        rowItems.length * 2 - 1,
                        (index) {
                          if (index.isOdd) {
                            return const SizedBox(width: 8);
                          }
                          final item = rowItems[index ~/ 2];
                          return Expanded(
                            child: InkWell(
                              onTap: item.disabled
                                  ? null
                                  : () {
                                      formFieldState.didChange(item.value); // pour validation
                                      setState(() {
                                        widget.controller.text = item.value;
                                      });
                                      widget.onChange(item);
                                    },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: item.disabled
                                      ? Colors.grey[300]
                                      : _isSelected(item)
                                          ? Theme.of(context).primaryColor.withAlpha(77)
                                          : Colors.white,
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor.withAlpha(90),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    item.label,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: item.disabled ? Colors.grey : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
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

  bool _isSelected(InputChoiceItem item) {
    return widget.controller.text == item.value;
  }
}
