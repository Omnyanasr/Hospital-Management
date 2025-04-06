import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String status;
  final String time;
  final String date;
  final String photo;
  final VoidCallback? onCancel;
  final bool showCancelButton; // ✅ Add this flag

  const AppointmentCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.status,
    required this.time,
    required this.date,
    required this.photo,
    this.onCancel,
    this.showCancelButton = true, // ✅ Default to true
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 25, backgroundImage: AssetImage(photo)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctorName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(specialty),
                      Text(
                        status,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: status == "Upcoming"
                              ? Colors.blue
                              : status == "Completed"
                                  ? Colors.green
                                  : Colors.red, // 🔴 For Cancelled
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(date,
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 5),
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(time,
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (status == "Upcoming" &&
                showCancelButton) // ✅ Conditionally show the Cancel button
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: onCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
