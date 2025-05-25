import 'package:doctodoc_mobile/shared/widgets/list_tile/appointment_list_tile.dart';
import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(50),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: AppointmentListTile(
              title: "Dr. Charlie Brown",
              subtitle: "Dentiste",
              color: Colors.white,
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.directions_outlined),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, color: Colors.green.shade900, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      "Dimanche 12 Sept.",
                      style: TextStyle(color: Colors.green.shade900, fontSize: 12),
                    ),
                  ],
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: Colors.green.shade900,
                ),
                Row(
                  children: [
                    Icon(Icons.access_time_outlined, color: Colors.green.shade900, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      "09:00 - 10:00",
                      style: TextStyle(color: Colors.green.shade900, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
