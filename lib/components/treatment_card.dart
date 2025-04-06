import 'package:flutter/material.dart';

class TreatmentCard extends StatelessWidget {
  final String name;
  final String dosage;

  const TreatmentCard({
    required this.name,
    required this.dosage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(220, 255, 255, 255),
      // soft blue
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min, // ✨ Auto-size the card
          children: [
            // Icon on the left
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE9F2FF),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.medical_services,
                  color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 10),

            // Texts
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dosage,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
