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
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: doctors.map((doc) {
                var data = doc.data() as Map<String, dynamic>;

                return Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed('/appointment', arguments: {
                        'doctorsId': doc.id,
                        'doctorName': data['Doctor\'s Name'] ?? "Unknown",
                        'specialty': data['Specialty'] ?? "Unknown Specialty",
                        'notes': data['Additional Notes'] ??
                            "No additional information",
                        'photo': data.containsKey('imageUrl') &&
                                data['imageUrl'] != null
                            ? data['imageUrl']
                            : 'assets/d.png',
                      });
                    },
                    child: FamilyMemberCard(
                      name: data['Doctor\'s Name'] ?? "Unknown",
                      role: data['Specialty'] ?? "Unknown Specialty",
                      imageUrl: data.containsKey('imageUrl') &&
                              data['imageUrl'] != null
                          ? data['imageUrl']
                          : 'assets/d.png',
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
