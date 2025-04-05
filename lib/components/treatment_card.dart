import 'package:flutter/material.dart';

class TreatmentCard extends StatelessWidget {
  final String name;
  final String dosage;

  TreatmentCard({required this.name, required this.dosage});

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
              Text(name,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
              SizedBox(height: 5),
              Text(dosage, style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
