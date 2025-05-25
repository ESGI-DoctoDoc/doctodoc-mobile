import 'package:flutter/material.dart';

class ExpansionTileBase extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? leading;
  final Widget? trailing;

  const ExpansionTileBase({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.0),
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withAlpha(33),
            width: 0.5,
          ),
        ),
        child: ExpansionTile(
          minTileHeight: 70,
          tilePadding: const EdgeInsets.only(right: 8, left: 16),
          title: _buildTitle(context),
          subtitle: _buildSubtitle(context),
          leading: leading,
          trailing: trailing,
          children: children,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    if (subtitle == null) {
      return null;
    } else {
      return Text(
        subtitle!,
      );
    }
  }
}
