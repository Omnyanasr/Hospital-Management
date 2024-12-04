import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:hospital_managment_project/controller/onboarding_controller_info.dart';

class DobSelectionScreen extends StatelessWidget {
  final OnboardingControllerInfo controller;

  DobSelectionScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("What is your date of birth?",
            style: TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2000), // Default date
              firstDate: DateTime(1920), // Minimum DOB
              lastDate: DateTime.now(), // Maximum DOB
            );

            if (pickedDate != null) {
              controller.setDateOfBirth(pickedDate);
            }
          },
          child: Obx(() {
            final dob = controller.dateOfBirth.value;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                dob != null
                    ? DateFormat('MMMM dd, yyyy')
                        .format(dob) // Format selected date
                    : "Tap to select your date of birth",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }),
        ),
      ],
    );
  }
}
