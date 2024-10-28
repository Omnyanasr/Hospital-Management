import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/controller/profile_controller.dart';

class AccountInformationPage extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  AccountInformationPage({super.key});

  // Accept the controller through the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Account Information",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage("assets/account.png"),
              backgroundColor: Colors.blue[100],
            ),
            const SizedBox(height: 20),
            ProfileInputField(
                label: "Name",
                value: controller.name.value,
                onChanged: (value) => controller.name.value = value),
            ProfileInputField(
                label: "Email",
                value: controller.email.value,
                onChanged: (value) => controller.email.value = value),
            ProfileInputField(
                label: "Phone",
                value: controller.phone.value,
                onChanged: (value) => controller.phone.value = value),
            ProfileInputField(
                label: "Location",
                value: controller.location.value,
                onChanged: (value) => controller.location.value = value),
            ProfileInputField(
                label: "Gender",
                value: controller.gender.value,
                onChanged: (value) => controller.gender.value = value),
            ProfileInputField(
                label: "Blood Type",
                value: controller.bloodType.value,
                onChanged: (value) => controller.bloodType.value = value),
            ProfileInputField(
                label: "Allergies",
                value: controller.allergies.value,
                onChanged: (value) => controller.allergies.value = value),
            ProfileInputField(
                label: "Chronic Conditions",
                value: controller.chronicConditions.value,
                onChanged: (value) =>
                    controller.chronicConditions.value = value),
            const SizedBox(
                height: 20), // Space between last input field and button
            ElevatedButton(
              onPressed: () {
                // Code to save changes
                controller.updateProfile(
                  controller.name.value,
                  controller.email.value,
                  controller.phone.value,
                  controller.location.value,
                  controller.gender.value,
                  controller.bloodType.value,
                  controller.allergies.value,
                  controller.chronicConditions.value,
                );
                Get.snackbar(
                  'Success',
                  'Profile updated successfully!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text("Save Changes"),
            ),
            const SizedBox(height: 20), // Additional bottom padding
          ],
        ),
      ),
    );
  }
}

class ProfileInputField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const ProfileInputField(
      {super.key,
      required this.label,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          TextFormField(
            initialValue: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.edit, color: Colors.grey),
              filled: true,
              fillColor: Colors.blue[50],
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
