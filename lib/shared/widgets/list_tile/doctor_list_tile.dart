import 'package:doctodoc_mobile/models/doctor/doctor.dart';
import 'package:doctodoc_mobile/shared/widgets/list_tile/base/list_tile_base.dart';
import 'package:flutter/material.dart';

class DoctorListTile extends StatelessWidget {
  final Doctor doctor;
  final Function? onTap;

  const DoctorListTile({
    super.key,
    required this.doctor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileBase(
      title: "Dr. ${doctor.firstName} ${doctor.lastName}",
      subtitle: doctor.speciality,
      leading: _buildLeadingIcon(context),
      trailing: const Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: Icon(Icons.arrow_forward_ios, size: 20),
      ),
      height: 78,
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        doctor.pictureUrl,
        height: 60,
        width: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 60,
            width: 60,
            color: Colors.grey.shade200,
            child: const Icon(Icons.visibility_off, size: 30, color: Colors.grey),
          );
        },
      ),
    );
  }
}
