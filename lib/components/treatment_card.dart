import 'package:flutter/material.dart';

class TreatmentCard extends StatelessWidget {
  final String name;
  final String dosage;
  final String time;

  TreatmentCard({required this.name, required this.dosage, required this.time});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(dosage, style: TextStyle(color: Colors.grey)),
              Text(time, style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}
