import 'package:flutter/material.dart';

class ListTileBase extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool isFlat;
  final Function()? onTap;
  final Color? color;
  final double? height;

  static ListTileBase dense({
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    Function()? onTap,
    final bool? isFlat,
  }) {
    return ListTileBase(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      isFlat: false,
      onTap: onTap,
      height: 54,
    );
  }

  static ListTileBase flat({
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    Function()? onTap,
    Color? color,
  }) {
    return ListTileBase(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      isFlat: true,
      onTap: onTap,
      color: color,
    );
  }

  const ListTileBase({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.isFlat = false,
    this.onTap,
    this.color,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: color ?? Theme.of(context).colorScheme.surfaceContainerLow,
        border: isFlat ? null : Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(33),
          width: 0.5,
        ),
      ),
      child: ListTile(
        minTileHeight: height,
        title: _buildTitle(context),
        leading: leading,
        trailing: trailing,
        subtitle: _buildSubtitle(context),
        contentPadding: const EdgeInsets.only(right: 4, left: 12),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    if (subtitle == null) {
      return null;
    } else {
      return Text(
        subtitle!,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      );
    }
  }
}
