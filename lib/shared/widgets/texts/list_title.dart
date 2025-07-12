import 'package:flutter/material.dart';

class ListTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  final Function? onTrailingTap;

  const ListTitle({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          child: trailing == null ? const SizedBox.shrink() : Text(
            trailing!,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () => onTrailingTap?.call()
        ),
      ],
    );
  }
}
