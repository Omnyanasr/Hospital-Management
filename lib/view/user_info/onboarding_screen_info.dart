import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/controller/onboarding_controller_info.dart';
import 'package:hospital_managment_project/view/user_info/allergy_selection_screen.dart';
import 'package:hospital_managment_project/view/user_info/chronic_disease_selection_screen.dart';
import 'package:hospital_managment_project/view/user_info/dob_selection_screen.dart';
import 'package:hospital_managment_project/view/user_info/gender_selection_screen.dart';
import 'package:hospital_managment_project/view/user_info/surgery_history_screen.dart';
import 'package:hospital_managment_project/view/user_info/weight_input_screen.dart';

class OnboardingScreenInfo extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  OnboardingScreenInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("Step ${controller.currentIndex.value + 1} / 4")),
      ),
      body: Center(
        child: Obx(() {
          print("Current index: ${controller.currentIndex.value}");

          // Render different screens based on currentIndex
          switch (controller.currentIndex.value) {
            case 0:
              return GenderAndDobSelectionScreen(controller: controller);
            case 1:
              return AllergySelectionScreen(controller: controller);
            case 2:
              return ChronicDiseaseSelectionScreen(controller: controller);
            case 3:
              return SurgeryHistoryScreen(controller: controller);
            default:
              return Container();
          }
        }),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.currentIndex.value = index,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.male), label: "Personal"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.healing), label: "Allergies"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.sick), label: "Diseases"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_hospital), label: "Surgeries"),
            ],
          )),
      floatingActionButton: Obx(() {
        print(
            "Checking FAB visibility, current index: ${controller.currentIndex.value}");
        return controller.currentIndex.value == 3
            ? FloatingActionButton(
                onPressed: () async {
                  print("Save button pressed at index 3");
                  // Ensure all data is filled in before completing onboarding
                  if (controller.gender.value.isEmpty ||
                      controller.dateOfBirth.value == null || // Check DOB
                      controller.weight.value <= 0 ||
                      controller.allergies.isEmpty ||
                      controller.chronicDiseases.isEmpty ||
                      controller.surgeries.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Please complete all steps before submitting.",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    await controller.completeOnboarding();
                  }
                },
                child: Icon(Icons.save),
              )
            : SizedBox
                .shrink(); // Return an empty widget if the condition is false
      }),
    );
  }
}












// floatingActionButton: Obx(() {
//         print(
//             "Checking FAB visibility, current index: ${controller.currentIndex.value}");
//         return controller.currentIndex.value == 3
//             ? Container(
//                 width: MediaQuery.of(context).size.width *
//                     0.8, // Make the button 80% of screen width
//                 margin: const EdgeInsets.all(16.0), // Add margin for spacing
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     print("Save button pressed at index 3");
//                     // Ensure all data is filled in before completing onboarding
//                     if (controller.gender.value.isEmpty ||
//                         controller.dateOfBirth.value == null ||
//                         controller.weight.value <= 0 ||
//                         controller.allergies.isEmpty ||
//                         controller.chronicDiseases.isEmpty ||
//                         controller.surgeries.isEmpty) {
//                       Get.snackbar(
//                         "Error",
//                         "Please complete all steps before submitting.",
//                         snackPosition: SnackPosition.BOTTOM,
//                       );
//                     } else {
//                       await controller.completeOnboarding();
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(
//                         vertical: 16), // Adjust padding for height
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(8), // Optional: rounded corners
//                     ),
//                   ),
//                   child: const Text(
//                     "Save",
//                     style: TextStyle(
//                       fontSize: 18, // Adjust text size as needed
//                       fontWeight: FontWeight.bold, // Optional: make text bold
//                     ),
//                   ),
//                 ),
//               )
//             : SizedBox
//                 .shrink(); // Return an empty widget if the condition is false
//       }),