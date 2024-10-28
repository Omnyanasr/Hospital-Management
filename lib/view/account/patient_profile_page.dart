import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/controller/profile_controller.dart';

class PatientProfilePage extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

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
            icon: Icons.location_on,
            title: 'Address',
            onTap: () {
              // Implement navigation or action for Address
            },
          ),
          _buildProfileOption(
            icon: Icons.payment,
            title: 'Payment Method',
            onTap: () {
              // Implement navigation or action for Payment Method
            },
          ),
          _buildProfileOption(
            icon: Icons.feedback,
            title: 'Feedback And Support',
            onTap: () {
              // Implement navigation or action for Help
            },
          ),
          _buildProfileOption(
            icon: Icons.info,
            title: 'About',
            onTap: () {
              // Implement navigation or action for About
            },
          ),
          _buildProfileOption(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              Get.offAllNamed("/login");
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
