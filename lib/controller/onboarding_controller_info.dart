import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/view/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hospital_managment_project/view/homepage.dart';

class OnboardingController extends GetxController {
  // Page management
  var currentIndex = 0.obs;

  // User data
  RxString gender = ''.obs;
  RxInt age = 0.obs;
  RxDouble weight = 70.0.obs;
  RxList<String> allergies = <String>[].obs;
  RxList<String> chronicDiseases = <String>[].obs;
  RxList<String> surgeries = <String>[].obs;
  Rxn<DateTime> dateOfBirth = Rxn<DateTime>();

  // "Other" inputs
  RxString otherAllergy = ''.obs;
  RxString otherChronic = ''.obs;
  RxString otherSurgery = ''.obs;

  // Data management
  void setGender(String selectedGender) => gender.value = selectedGender;
  void setAge(int selectedAge) => age.value = selectedAge;
  void setWeight(double selectedWeight) => weight.value = selectedWeight;

  void toggleAllergy(String allergy) {
    allergies.contains(allergy)
        ? allergies.remove(allergy)
        : allergies.add(allergy);
  }

  void toggleChronicDisease(String disease) {
    chronicDiseases.contains(disease)
        ? chronicDiseases.remove(disease)
        : chronicDiseases.add(disease);
  }

  void toggleSurgery(String surgery) {
    surgeries.contains(surgery)
        ? surgeries.remove(surgery)
        : surgeries.add(surgery);
  }

  void setOtherAllergy(String allergy) {
    otherAllergy.value = allergy;
    if (allergy.isNotEmpty && !allergies.contains("Other")) {
      allergies.add("Other");
    } else if (allergy.isEmpty && allergies.contains("Other")) {
      allergies.remove("Other");
    }
  }

  void setOtherChronic(String chronic) {
    otherChronic.value = chronic;
    if (chronic.isNotEmpty && !chronicDiseases.contains("Other")) {
      chronicDiseases.add("Other");
    } else if (chronic.isEmpty && chronicDiseases.contains("Other")) {
      chronicDiseases.remove("Other");
    }
  }

  void setOtherSurgery(String surgery) {
    otherSurgery.value = surgery;
    if (surgery.isNotEmpty && !surgeries.contains("Other")) {
      surgeries.add("Other");
    } else if (surgery.isEmpty && surgeries.contains("Other")) {
      surgeries.remove("Other");
    }
  }

  void setDateOfBirth(DateTime dob) => dateOfBirth.value = dob;

  Future<void> completeOnboarding() async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      // Save data to Firestore
      await _saveDataToFirestore();

      // Mark onboarding as complete
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasCompletedOnboarding', true);

      // Navigate to the home screen
      Get.offAll(() => Login());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to complete onboarding: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      Get.back(); // Close the loading dialog
    }
  }

  Future<void> _saveDataToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'gender': gender.value,
          'age': age.value,
          'weight': weight.value,
          'allergies': allergies,
          'chronicDiseases': chronicDiseases,
          'surgeries': surgeries,
          'dateOfBirth': dateOfBirth.value != null
              ? Timestamp.fromDate(dateOfBirth.value!)
              : null,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        throw Exception('Failed to save user data: $e');
      }
    } else {
      throw Exception('User not authenticated.');
    }
  }

  Future<bool> hasCompletedOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasCompletedOnboarding') ?? false;
  }
}
