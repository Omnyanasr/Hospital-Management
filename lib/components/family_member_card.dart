import 'package:flutter/material.dart';

class FamilyMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;

  const FamilyMemberCard({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    bool isNetworkImage = imageUrl.startsWith('http');

    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: isNetworkImage
              ? NetworkImage(imageUrl) // Firestore image URL
              : AssetImage('assets/doctor.png') as ImageProvider, // Local asset
        ),
        const SizedBox(height: 5),
        Text(name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
        Text(role, style: const TextStyle(color: Colors.grey, fontSize: 9)),
      ],
    );
  }
}
