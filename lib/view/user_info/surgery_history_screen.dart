import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/controller/onboarding_controller_info.dart';

class SurgeryHistoryScreen extends StatelessWidget {
  final OnboardingControllerInfo controller;

  SurgeryHistoryScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text("Have you had any surgeries?",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),

                    SizedBox(height: 13),

                    // Surgery options (converted from chips to list tiles)
                    _buildSurgeryOption("Internal organ surgeries"),
                    _buildSurgeryOption("Orthopedic operations"),
                    _buildSurgeryOption("Neurosurgery"),
                    //_buildSurgeryOption("Spinal surgery"),
                    _buildSurgeryOption("Eye operations"),
                    // _buildSurgeryOption(
                    //     "Ear, Nose, and Throat (ENT) surgeries"),
                    _buildSurgeryOption("No surgeries"),
                    _buildSurgeryOption(
                        "Other"), // 'Other' chip to trigger the input field
                    // Conditionally show a TextFormField when "Other" is selected
                    Obx(() {
                      return controller.surgeries.contains("Other")
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText:
                                      "Please specify your surgery history",
                                  border: OutlineInputBorder(),
                                  hintText: "Enter your surgery history",
                                ),
                                onChanged: (value) {
                                  controller.setOtherSurgery(value);
                                },
                              ),
                            )
                          : Container();
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSurgeryOption(String label) {
    return Obx(() {
      bool isSelected = controller.surgeries.contains(label);
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : const Color.fromARGB(
                    255, 141, 140, 140), // Dynamic border color
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: ListTile(
          title: Text(label),
          trailing: const SizedBox.shrink(), // Hides the trailing checkbox
          onTap: () {
            if (isSelected) {
              controller.surgeries.remove(label);
            } else {
              controller.toggleSurgery(label);
            }
          },
        ),
      );
    });
  }
}
