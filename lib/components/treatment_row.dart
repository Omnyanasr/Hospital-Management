import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital_managment_project/components/treatment_card.dart';

class TreatmentRow extends StatelessWidget {
  const TreatmentRow({super.key});

  Future<List<Map<String, dynamic>>> fetchTreatments() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('⚠️ User not logged in');
        return [];
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final data = doc.data();
      if (data == null || data['treatments'] == null) {
        print('⚠️ No treatments found');
        return [];
      }

      final List<dynamic> treatmentList = data['treatments'];

      final List<Map<String, dynamic>> treatments = treatmentList
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      return treatments;
    } catch (e, stack) {
      print('❌ Error fetching treatments: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchTreatments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text('Error loading treatments');
        }

        final treatments = snapshot.data ?? [];

        if (treatments.isEmpty) {
          return const Text('No treatments found');
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: treatments.map((treatment) {
              final timestamp = treatment['timestamp'];
              final timeString = timestamp != null && timestamp is Timestamp
                  ? "${timestamp.toDate().hour.toString().padLeft(2, '0')}:${timestamp.toDate().minute.toString().padLeft(2, '0')}"
                  : 'N/A';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TreatmentCard(
                  name: treatment['details'] ?? 'Unnamed',
                  dosage: '1 dose / day', // Update with real dosage if needed
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
