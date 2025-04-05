import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital_managment_project/components/treatment_card.dart';

class TreatmentRow extends StatelessWidget {
  const TreatmentRow({super.key});

  Future<List<Map<String, dynamic>>> fetchTreatments() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = doc.data();
    if (data == null || data['treatments'] == null) return [];

    List<dynamic> rawTreatments = data['treatments'];
    return rawTreatments.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchTreatments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error loading treatments');
        }

        final treatments = snapshot.data ?? [];

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: treatments.map((treatment) {
              return TreatmentCard(
                name: treatment['details'] ?? 'Unknown',
                dosage: '1 dose / day', // You can add dosage if it's stored
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
