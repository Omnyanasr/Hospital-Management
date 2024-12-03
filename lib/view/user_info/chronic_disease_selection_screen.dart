import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hospital_managment_project/controller/onboarding_controller_info.dart';

class ChronicDiseaseSelectionScreen extends StatelessWidget {
  final OnboardingController controller;

  ChronicDiseaseSelectionScreen({required this.controller});

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
                    Text("Do you have chronic diseases?",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),

                    SizedBox(height: 13),

                    // Options for chronic diseases
                    _buildDiseaseOption("Diabetes"),
                    _buildDiseaseOption("Asthma"),
                    //_buildDiseaseOption("Kidney disease"),
                    _buildDiseaseOption("Arthritis"),
                    //_buildDiseaseOption("Heart failure"),
                    //_buildDiseaseOption("Hypertension (High Blood Pressure)"),
                    _buildDiseaseOption("Obesity"),
                    _buildDiseaseOption("No chronic diseases"),
                    _buildDiseaseOption(
                        "Other"), // 'Other' chip to trigger the input field
                    // Conditionally show a TextFormField when "Other" is selected
                    Obx(() {
                      return controller.chronicDiseases.contains("Other")
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText:
                                      "Please specify your chronic disease",
                                  border: OutlineInputBorder(),
                                  hintText: "Enter your chronic disease",
                                ),
                                onChanged: (value) {
                                  controller.setOtherChronic(value);
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

  Widget _buildDiseaseOption(String label) {
    return Obx(() {
      bool isSelected = controller.chronicDiseases.contains(label);
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
              controller.chronicDiseases.remove(label);
            } else {
              controller.toggleChronicDisease(label);
            }
          },
        ),
      );
    });
  }
}
