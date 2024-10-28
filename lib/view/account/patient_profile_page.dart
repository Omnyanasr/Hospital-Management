import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/controller/profile_controller.dart';

class PatientProfilePage extends StatelessWidget {
  // Use Get.put to initialize the controller
  final ProfileController controller = Get.find<ProfileController>();

  PatientProfilePage({super.key}); // Constructor with key

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
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
                'assets/account.png'), // Replace with actual path or network image
          ),
          const SizedBox(height: 10),
          Obx(() => Text(
                controller.name.value, // Use the controller's observable value
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 30),
          // Add profile options
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
            icon: Icons.help,
            title: 'Help',
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

  // Reusable widget for profile options
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
