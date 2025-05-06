import 'package:doctodoc_mobile/shared/config/theme.dart';
import 'package:flutter/material.dart';

class InputDate extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final DateTime? min;
  final DateTime? max;
  final VoidCallback? onChanged;

  const InputDate({
    super.key,
    required this.controller,
    required this.label,
    this.min,
    this.max,
    this.onChanged,
  });

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: widget.min ?? DateTime(1900),
      lastDate: widget.max ?? DateTime(2100),
      initialDate: () {
        final now = DateTime.now();
        final first = widget.min ?? DateTime(1900);
        final last = widget.max ?? DateTime(2100);
        if (now.isBefore(first)) return first;
        if (now.isAfter(last)) return last;
        return now;
      }(),
    );
    if (picked != null) {
      if (widget.min != null && widget.max != null) {
        if (picked.isAfter(widget.min!) && picked.isBefore(widget.max!)) {
          setState(() {
            widget.controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
          });
          widget.onChanged?.call();
        }
      } else if (widget.min != null) {
        if (picked.isAfter(widget.min!) || picked.isAtSameMomentAs(widget.min!)) {
          setState(() {
            widget.controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
          });
          widget.onChanged?.call();
        }
      } else if (widget.max != null) {
        if (picked.isBefore(widget.max!) || picked.isAtSameMomentAs(widget.max!)) {
          setState(() {
            widget.controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
          });
          widget.onChanged?.call();
        }
      } else {
        setState(() {
          widget.controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
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
              color: Theme.of(context)
                  .extension<CustomColors>()!
                  .success,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                const BorderRadius.all(Radius.circular(inputBorderRadius)),
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

// todo add primary color,
// todo add reactivity
// todo add props
class InputDateNoModal extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const InputDateNoModal({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  State<InputDateNoModal> createState() => _InputDateNoModalState();
}

class _InputDateNoModalState extends State<InputDateNoModal> {
  @override
  Widget build(BuildContext context) {
    DateTime _selectedDate = DateTime.now();
    const inputBorderRadius = 12.0;

    return Material(
      elevation: 0.5,
      borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          border: Border.all(
            color: Theme.of(context)
                .dividerColor
                .withAlpha(77),
            width: 1.0,
          ),
        ),
        child: CalendarDatePicker(
          initialDate: _selectedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          onDateChanged: (date) {
            setState(() {
              _selectedDate = date;
              widget.controller.text =
                  "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
            });
          },
        ),
      ),
    );
  }
}
