import 'package:flutter/material.dart';

class FamilyMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;

  FamilyMemberCard(
      {required this.name, required this.role, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage:
              AssetImage(imagePath), // Replace with your image asset
        ),
        SizedBox(height: 5),
        Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(role, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
