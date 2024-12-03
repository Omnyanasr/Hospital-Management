import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileController extends GetxController {
  // User data
  var name = 'User'.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var location = ''.obs;
  var gender = ''.obs;
  var bloodType = ''.obs;
  var allergies = <String>[].obs;
  var surgeries = <String>[].obs;
  var chronicConditions = <String>[].obs;
  var profileImagePath = ''.obs;
  var dateOfBirth = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  // Load user profile data
  Future<void> loadUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          name.value = data['username'] ?? 'User';
          email.value = user.email ?? '';
          phone.value = data['phone'] ?? '';
          location.value = data['location'] ?? 'Alexandria';
          gender.value = data['gender'] ?? '';
          bloodType.value = data['bloodType'] ?? 'Unknown';
          allergies.value = data['allergies'] is List
              ? List<String>.from(data['allergies'])
              : [];
          chronicConditions.value = data['chronicDiseases'] is List
              ? List<String>.from(data['chronicDiseases'])
              : [];
          surgeries.value = data['surgeries'] is List
              ? List<String>.from(data['surgeries'])
              : [];
          profileImagePath.value = data['profileImagePath'] ?? '';
          dateOfBirth.value = (data['dateOfBirth'] as Timestamp?)?.toDate();
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Upload image to Firebase Storage and get the URL
  Future<String> uploadProfileImage(File image) async {
    try {
      String fileName =
          'profileImages/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(image);

      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? newName,
    String? newPhone,
    String? newLocation,
    String? newGender,
    String? newBloodType,
    List<String>? newAllergies,
    List<String>? newChronicConditions,
    List<String>? newSurgeries,
    DateTime? newDateOfBirth,
    required String newEmail,
    File? newProfileImage, // Adding image parameter
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Upload image if a new one is provided
        String? newImagePath;
        if (newProfileImage != null) {
          newImagePath = await uploadProfileImage(newProfileImage);
        }

        // Update Firestore document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'username': newName ?? name.value,
          'phone': newPhone ?? phone.value,
          'location': newLocation ?? location.value,
          'gender': newGender ?? gender.value,
          'bloodType': newBloodType ?? bloodType.value,
          'allergies': newAllergies ?? allergies,
          'chronicConditions': newChronicConditions ?? chronicConditions,
          'surgeries': newSurgeries ?? surgeries,
          'dateOfBirth': newDateOfBirth ?? dateOfBirth.value,
          'profileImagePath':
              newImagePath ?? profileImagePath.value, // Save image path
        });

        await user.verifyBeforeUpdateEmail(newEmail);
        email.value = newEmail;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
