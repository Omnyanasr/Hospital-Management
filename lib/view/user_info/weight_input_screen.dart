import 'package:flutter/material.dart';
import 'package:hospital_managment_project/controller/onboarding_controller_info.dart';

class WeightInputScreen extends StatelessWidget {
  final OnboardingControllerInfo controller;

  WeightInputScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("What is your weight?", style: TextStyle(fontSize: 18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove, size: 30),
              onPressed: () {
                if (controller.weight.value > 30) {
                  controller.setWeight(controller.weight.value - 1);
                }
              },
            ),
            SizedBox(
              width: 80,
              child: TextFormField(
                controller: TextEditingController(
                  text: controller.weight.value.toStringAsFixed(1),
                ),
                readOnly: true, // Prevents user from typing directly
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Weight',
                ),
                onTap: () {
                  // Optionally, you can allow the user to input directly when tapping on the field
                  // or open a dialog to enter the value manually.
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, size: 30),
              onPressed: () {
                if (controller.weight.value < 150) {
                  controller.setWeight(controller.weight.value + 1);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
