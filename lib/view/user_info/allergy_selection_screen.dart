import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hospital_managment_project/controller/onboarding_controller_info.dart';

class AllergySelectionScreen extends StatelessWidget {
  final OnboardingController controller;

  AllergySelectionScreen({required this.controller});

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
                    Text("Do you have allergies?",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),

                    SizedBox(height: 13),

                    // Chips for predefined options
                    _buildAllergyCheckbox("Pollen"),
                    _buildAllergyCheckbox("Animal fur"),
                    _buildAllergyCheckbox("House dust"),
                    _buildAllergyCheckbox("Medicines"),
                    _buildAllergyCheckbox("No allergies"),
                    _buildAllergyCheckbox(
                        "Other"), // 'Other' chip to trigger the input field

                    // Conditionally show a TextFormField when "Other" is selected
                    Obx(() {
                      return controller.allergies.contains("Other")
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Please specify your allergy",
                                  border: OutlineInputBorder(),
                                  hintText: "Enter your allergies",
                                ),
                                onChanged: (value) {
                                  controller.setOtherAllergy(value);
                                },
                              ),
                            )
                          : Container();
                    }),
                  ],
                ),
              ),
            ),

            // Save Button

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergyCheckbox(String label) {
    return Obx(() {
      bool isSelected = controller.allergies.contains(label);
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
              controller.allergies.remove(label);
            } else {
              controller.toggleAllergy(label);
            }
            if (label != "Other") {
              controller.setOtherAllergy("");
            }
          },
        ),
      );
    });
  }
}
