import 'package:doctodoc_mobile/shared/widgets/list_tile/base/list_tile_base.dart';
import 'package:flutter/material.dart';

class AppointmentListTile extends StatelessWidget {
  final String title; //todo use Appointment model ?
  final String subtitle;
  final Widget? trailing;
  final Color? color;

  const AppointmentListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileBase.flat(
      title: title,
      subtitle: subtitle,
      leading: _buildLeadingIcon(context),
      trailing: trailing,
      color: color,
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d",
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      ),
    );
  }
}
