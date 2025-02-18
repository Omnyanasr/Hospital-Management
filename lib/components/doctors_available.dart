import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital_managment_project/components/family_member_card.dart';

class DoctorsAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("doctors").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No doctors available"));
        }

        var doctors = snapshot.data!.docs;

        return SizedBox(
          height: 140, // Increased height for better visibility
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Enables horizontal scrolling
            child: Row(
              children: doctors.map((doc) {
                var data = doc.data() as Map<String, dynamic>;

                return Container(
                  width: 120, // Increased width per doctor card
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10), // More spacing
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed('/appointment',
                          arguments: data['Doctor\'s Name']);
                    },
                    child: FamilyMemberCard(
                      name: data['Doctor\'s Name'] ?? "Unknown",
                      role: data['Specialty'] ?? "Unknown Specialty",
                      imageUrl: data.containsKey('imageUrl') &&
                              data['imageUrl'] != null
                          ? data['imageUrl']
                          : 'assets/doctor.png',
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
