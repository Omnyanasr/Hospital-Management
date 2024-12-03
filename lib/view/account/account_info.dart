import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/components/profile_input_feild.dart';
import 'package:hospital_managment_project/controller/profile_controller.dart';
import 'package:image_picker/image_picker.dart';

class AccountInformationPage extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();
  final ImagePicker _picker = ImagePicker();
  final RxBool isLoading = false.obs;

  AccountInformationPage({super.key});

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        controller.profileImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> _pickDateOfBirth(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.dateOfBirth.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      controller.dateOfBirth.value = pickedDate;
    }
  }

  Future<void> _saveProfile() async {
    if (!GetUtils.isEmail(controller.email.value)) {
      Get.snackbar('Error', 'Please enter a valid email.');
      return;
    }
    if (controller.phone.value.length < 10) {
      Get.snackbar('Error', 'Phone number must be at least 10 digits.');
      return;
    }

    isLoading.value = true;

    try {
      await controller.updateProfile(
        newName: controller.name.value,
        newEmail: controller.email.value,
        newPhone: controller.phone.value,
        newLocation: controller.location.value,
        newGender: controller.gender.value,
        newBloodType: controller.bloodType.value,
        newAllergies: controller.allergies.value,
        newChronicConditions: controller.chronicConditions.value,
        newSurgeries: controller.surgeries.value,
        newDateOfBirth: controller.dateOfBirth.value,
      );

      Get.snackbar('Success', 'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

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
            GestureDetector(
              onTap: _pickImage,
              child: Obx(() => CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        controller.profileImagePath.value.isNotEmpty
                            ? FileImage(File(controller.profileImagePath.value))
                                as ImageProvider<Object>
                            : const AssetImage('assets/account.png')
                                as ImageProvider<Object>,
                  )),
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
            const SizedBox(height: 16),
            Obx(() => TextField(
                  controller: TextEditingController(
                    text: controller.allergies.value.join(', '),
                  ),
                  decoration: const InputDecoration(labelText: 'Allergies'),
                  onChanged: (value) {
                    controller.allergies.value =
                        value.split(',').map((e) => e.trim()).toList();
                  },
                )),
            const SizedBox(height: 16),
            Obx(() => TextField(
                  controller: TextEditingController(
                    text: controller.chronicConditions.value.join(', '),
                  ),
                  decoration:
                      const InputDecoration(labelText: 'Chronic Conditions'),
                  onChanged: (value) {
                    controller.chronicConditions.value =
                        value.split(',').map((e) => e.trim()).toList();
                  },
                )),
            const SizedBox(height: 16),
            Obx(() => TextField(
                  controller: TextEditingController(
                    text: controller.surgeries.value.join(', '),
                  ),
                  decoration:
                      const InputDecoration(labelText: 'Past Surgeries'),
                  onChanged: (value) {
                    controller.surgeries.value =
                        value.split(',').map((e) => e.trim()).toList();
                  },
                )),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
                  onPressed: isLoading.value ? null : _saveProfile,
                  child: isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save Changes"),
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
