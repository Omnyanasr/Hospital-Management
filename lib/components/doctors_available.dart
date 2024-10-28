import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Ensure you have GetX for navigation
import 'package:hospital_managment_project/components/family_member_card.dart';

class DoctorsAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of doctors with their details
    final List<Map<String, String>> doctors = [
      {"name": "Hanna Hall", "role": "Wife", "imagePath": 'assets/doctor.png'},
      {"name": "Oliver Hall", "role": "Son", "imagePath": 'assets/doctor.png'},
      {"name": "Eva Hall", "role": "Mother", "imagePath": 'assets/doctor.png'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: doctors.map((doctor) {
        return GestureDetector(
          onTap: () {
            // Navigate to the appointment page with the selected doctor's name
            Get.toNamed('/appointment', arguments: doctor['name']);
          },
          child: FamilyMemberCard(
            name: doctor['name']!,
            role: doctor['role']!,
            imagePath: doctor['imagePath']!,
          ),
        );
      }).toList(),
    );
  }
}
