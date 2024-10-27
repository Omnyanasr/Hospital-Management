import 'package:flutter/material.dart';
import 'package:hospital_managment_project/components/family_member_card.dart';

class DoctorsAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FamilyMemberCard(
            name: "Hanna Hall", role: "Wife", imagePath: 'assets/doctor.png'),
        FamilyMemberCard(
            name: "Oliver Hall", role: "Son", imagePath: 'assets/doctor.png'),
        FamilyMemberCard(
            name: "Eva Hall", role: "Mother", imagePath: 'assets/doctor.png'),
      ],
    );
  }
}
