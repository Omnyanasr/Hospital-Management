import 'package:flutter/material.dart';
import 'package:hospital_managment_project/components/family_member_card.dart';

class FamilyRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FamilyMemberCard(
            name: "Hanna Hall", role: "Wife", imagePath: 'assets/hanna.jpg'),
        FamilyMemberCard(
            name: "Oliver Hall", role: "Son", imagePath: 'assets/oliver.jpg'),
        FamilyMemberCard(
            name: "Eva Hall", role: "Mother", imagePath: 'assets/eva.jpg'),
      ],
    );
  }
}
