import 'package:doctodoc_mobile/shared/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class InputDate extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final DateTime min;
  final DateTime max;
  final VoidCallback? onChanged;

  const InputDate({
    super.key,
    required this.controller,
    required this.label,
    required this.min,
    required this.max,
    this.onChanged,
  });

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: widget.min,
      lastDate: widget.max,
      initialDate: () {
        final now = DateTime.now();
        final first = widget.min;
        final last = widget.max;
        if (now.isBefore(first)) return first;
        if (now.isAfter(last)) return last;
        return now;
      }(),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      if (picked.isAfter(widget.min) && picked.isBefore(widget.max)) {
        setState(() {
          widget.controller.text =
              "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
        });
        widget.onChanged?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const inputBorderRadius = 12.0;
    const inputHeight = 16.0;

    return Material(
      elevation: 0.5,
      borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
      child: TextField(
        controller: widget.controller,
        readOnly: true,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(inputBorderRadius),
            borderSide: BorderSide(
              color: Theme.of(context).extension<CustomColors>()!.success,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withAlpha(77),
              width: 0.5,
            ),
          ),
          hintText: "JJ/MM/AAAA",
          label: Text(widget.label),
          contentPadding: const EdgeInsets.all(inputHeight),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(inputBorderRadius),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                widget.controller.clear();
                widget.onChanged?.call();
              });
            },
            icon: const Icon(Icons.clear),
          ),
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }
}

class InputDateNoModal extends StatefulWidget {
  final DateTime min;
  final DateTime max;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const InputDateNoModal({
    super.key,
    required this.controller,
    required this.min,
    required this.max,
    this.validator,
  });

  @override
  State<InputDateNoModal> createState() => _InputDateNoModalState();
}

class _InputDateNoModalState extends State<InputDateNoModal> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    const inputBorderRadius = 12.0;

    return FormField<String>(
      validator: widget.validator,
      initialValue: widget.controller.text,
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 0.5,
              borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(inputBorderRadius),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withAlpha(77),
                    width: 1.0,
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: widget.min,
                  lastDate: widget.max,
                  onDateChanged: (date) {
                    print(date.toString());
                    final dateTime = DateTime(date.year, date.month, date.day);
                    final formattedDate =
                        Jiffy.parseFromDateTime(dateTime).format(pattern: 'yyyy-MM-dd').toString();
                    setState(() {
                      selectedDate = date;
                    });
                    formFieldState.didChange(formattedDate);
                    widget.controller.text = formattedDate;
                  },
                ),
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
}
