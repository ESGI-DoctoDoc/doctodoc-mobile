import 'package:doctodoc_mobile/shared/widgets/list_tile/base/list_tile_base.dart';
import 'package:flutter/material.dart';

class DoctorListTile extends StatelessWidget {
  const DoctorListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileBase(
      title: "Dr. John Doe",
      subtitle: "Cardiologist",
      leading: _buildLeadingIcon(context),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Icon(Icons.arrow_forward_ios, size: 20),
      ),
      height: 78,
      onTap: () {
        // Handle tap action
        print("Doctor List Tile tapped");
      },
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
