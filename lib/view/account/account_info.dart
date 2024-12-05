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
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController chronicConditionsController =
      TextEditingController();
  final TextEditingController surgeriesController = TextEditingController();

  AccountInformationPage({super.key}) {
    // Link controllers to Rx variables
    allergiesController.text = controller.allergies.value.join(', ');
    chronicConditionsController.text =
        controller.chronicConditions.value.join(', ');
    surgeriesController.text = controller.surgeries.value.join(', ');

    // Update controllers when Rx variables change
    controller.allergies.listen((value) {
      allergiesController.text = value.join(', ');
    });

    controller.chronicConditions.listen((value) {
      chronicConditionsController.text = value.join(', ');
    });

    controller.surgeries.listen((value) {
      surgeriesController.text = value.join(', ');
    });
  }

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
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.bloodType.value.isNotEmpty
                      ? controller.bloodType.value
                      : "Unknown",
                  items: [
                    'A+',
                    'A-',
                    'B+',
                    'B-',
                    'O+',
                    'O-',
                    'AB+',
                    'AB-',
                    "Unknown"
                  ]
                      .map((bloodType) => DropdownMenuItem(
                            value: bloodType,
                            child: Text(bloodType),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: "Blood Type",
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(227, 242, 253, 1), // Border color
                        width: 2.0, // Border thickness
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(
                            227, 242, 253, 1), // Border color when not focused
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(
                            164, 210, 242, 1), // Border color when focused
                        width: 2.5, // Thicker border when focused
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      controller.bloodType.value = value;
                    }
                  },
                )),
            const SizedBox(height: 16),
            TextField(
              controller: allergiesController,
              decoration: const InputDecoration(labelText: 'Allergies'),
              onChanged: (value) {
                final updatedAllergies = value
                    .split(',')
                    .map((e) => e.trimLeft()) // Trim leading spaces
                    .toList();

                // Filter out consecutive empty entries
                final cleanedAllergies = <String>[];
                for (var i = 0; i < updatedAllergies.length; i++) {
                  // Add to cleaned list only if not empty or not consecutive
                  if (updatedAllergies[i].isNotEmpty ||
                      (i > 0 && updatedAllergies[i - 1].isNotEmpty)) {
                    cleanedAllergies.add(updatedAllergies[i]);
                  }
                }

                // Update the allergies list
                controller.allergies.value = cleanedAllergies;

                // Rebuild the text field content with cleaned input
                allergiesController.value = TextEditingValue(
                  text: cleanedAllergies
                      .join(', '), // Join list into a clean string
                  selection: TextSelection.collapsed(
                      offset: cleanedAllergies.join(', ').length),
                );

                print(controller.allergies.value); // Debugging output
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: chronicConditionsController,
              decoration:
                  const InputDecoration(labelText: 'Chronic Conditions'),
              onChanged: (value) {
                final updatedConditions =
                    value.split(',').map((e) => e.trimLeft()).toList();

                final cleanedConditions = <String>[];
                for (var i = 0; i < updatedConditions.length; i++) {
                  if (updatedConditions[i].isNotEmpty ||
                      (i > 0 && updatedConditions[i - 1].isNotEmpty)) {
                    cleanedConditions.add(updatedConditions[i]);
                  }
                }

                controller.chronicConditions.value = cleanedConditions;

                chronicConditionsController.value = TextEditingValue(
                  text: cleanedConditions.join(', '),
                  selection: TextSelection.collapsed(
                    offset: cleanedConditions.join(', ').length,
                  ),
                );

                print(controller.chronicConditions.value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: surgeriesController,
              decoration: const InputDecoration(labelText: 'Past Surgeries'),
              onChanged: (value) {
                final updatedSurgeries =
                    value.split(',').map((e) => e.trimLeft()).toList();

                final cleanedSurgeries = <String>[];
                for (var i = 0; i < updatedSurgeries.length; i++) {
                  if (updatedSurgeries[i].isNotEmpty ||
                      (i > 0 && updatedSurgeries[i - 1].isNotEmpty)) {
                    cleanedSurgeries.add(updatedSurgeries[i]);
                  }
                }

                controller.surgeries.value = cleanedSurgeries;

                surgeriesController.value = TextEditingValue(
                  text: cleanedSurgeries.join(', '),
                  selection: TextSelection.collapsed(
                    offset: cleanedSurgeries.join(', ').length,
                  ),
                );

                print(controller.surgeries.value);
              },
            ),
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
