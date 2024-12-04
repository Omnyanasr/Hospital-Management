import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hospital_managment_project/controller/onboarding_controller_info.dart';
import 'package:intl/intl.dart';

class GenderAndDobSelectionScreen extends StatefulWidget {
  final OnboardingControllerInfo controller; // Controller passed to the screen

  GenderAndDobSelectionScreen({required this.controller});

  @override
  _GenderAndDobSelectionScreenState createState() =>
      _GenderAndDobSelectionScreenState();
}

class _GenderAndDobSelectionScreenState
    extends State<GenderAndDobSelectionScreen> {
  String selectedGender = ""; // Track the selected gender locally
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            // Gender selection section
            Text(
              "What is your gender?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // SizedBox(height: 5),
            // Text(
            //   "Knowing the gender allows doctors to get additional information about the patient, which can be an important part of the medical history.",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Colors.grey,
            //   ),
            // ),
            SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _genderOption(
                  title: "Male",
                  icon: Icons.male,
                  isSelected: selectedGender == "Male",
                  onTap: () {
                    setState(() {
                      selectedGender = "Male";
                    });
                    widget.controller.setGender("Male");
                  },
                ),
                SizedBox(width: 20),
                _genderOption(
                  title: "Female",
                  icon: Icons.female,
                  isSelected: selectedGender == "Female",
                  onTap: () {
                    setState(() {
                      selectedGender = "Female";
                    });
                    widget.controller.setGender("Female");
                  },
                ),
              ],
            ),
            SizedBox(height: 40),
            // Date of Birth selection section
            Text(
              "What is your date of birth?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 13),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000), // Default date
                  firstDate: DateTime(1920), // Minimum DOB
                  lastDate: DateTime.now(), // Maximum DOB
                );

                if (pickedDate != null) {
                  widget.controller.setDateOfBirth(pickedDate);
                }
              },
              child: Obx(() {
                final dob = widget.controller.dateOfBirth.value;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    dob != null
                        ? DateFormat('MMMM dd, yyyy').format(dob)
                        : "Tap to select your date of birth",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              }),
            ),
            SizedBox(height: 40),
            // Weight input section
            Text(
              "What is your weight?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 13),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, size: 30),
                  onPressed: () {
                    if (widget.controller.weight.value > 30) {
                      widget.controller
                          .setWeight(widget.controller.weight.value - 1);
                      weightController.text =
                          widget.controller.weight.value.toStringAsFixed(1);
                    }
                  },
                ),
                IntrinsicWidth(
                  // This will ensure the TextFormField wraps content in width.
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: 150), // Limit max width if necessary
                    child: TextFormField(
                      controller: weightController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        // Only allow numbers and one decimal point
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,1}')),
                      ],
                      textAlign: TextAlign.center,
                      maxLines: 1, // Ensures only one line of text is visible
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Wieght (kg) ',
                        labelText: 'Weight (kg)',
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          double? weight = double.tryParse(value);
                          if (weight != null && weight > 0) {
                            widget.controller.setWeight(weight);
                          }
                        }
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 30),
                  onPressed: () {
                    if (widget.controller.weight.value < 150) {
                      widget.controller
                          .setWeight(widget.controller.weight.value + 1);
                      weightController.text =
                          widget.controller.weight.value.toStringAsFixed(1);
                    }
                  },
                ),
              ],
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Gender option widget
  Widget _genderOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
