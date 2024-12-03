import 'package:flutter/material.dart';

class FamilyMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;

  const FamilyMemberCard(
      {super.key,
      required this.name,
      required this.role,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage:
              AssetImage(imagePath), // Replace with your image asset
        ),
        const SizedBox(height: 5),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(role, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
