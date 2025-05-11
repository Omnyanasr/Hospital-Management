import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hospital_managment_project/controller/profile_controller.dart';

class PatientProfilePage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  PatientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Obx(() {
            ImageProvider<Object> profileImageProvider;

            if (controller.profileImagePath.value.isNotEmpty &&
                File(controller.profileImagePath.value).existsSync()) {
              profileImageProvider =
                  FileImage(File(controller.profileImagePath.value));
            } else {
              profileImageProvider = const AssetImage('assets/account.png');
            }

            return CircleAvatar(
              radius: 50,
              backgroundImage: profileImageProvider,
              backgroundColor: Colors.blue[100],
            );
          }),
          const SizedBox(height: 10),
          Obx(() => Text(
                controller.name.value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 30),
          _buildProfileOption(
            icon: Icons.person,
            title: 'Personal Details',
            onTap: () {
              Get.toNamed("/info");
            },
          ),
          _buildProfileOption(
            icon: Icons.payment,
            title: 'Payment Method',
            onTap: () {
              Get.toNamed("/payment");
            },
          ),
          _buildProfileOption(
            icon: Icons.feedback,
            title: 'Feedback And Support',
            onTap: () {
              Get.toNamed("/feedback");
            },
          ),
          _buildProfileOption(
            icon: Icons.info,
            title: 'About',
            onTap: () {
              Get.toNamed("/about");
            },
          ),
          _buildProfileOption(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              await googleSignIn.signOut(); // Sign out from Google
              await FirebaseAuth.instance.signOut(); // Sign out from Firebase

              Get.offNamed('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
