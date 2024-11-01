import 'package:get/get.dart';

class ProfileController extends GetxController {
  var name = 'User'.obs;
  String get firstName => name.value.split(' ')[0];
  var email = ''.obs;
  var phone = ''.obs;
  var location = ''.obs;
  var gender = ''.obs;
  var bloodType = ''.obs;
  var allergies = ''.obs;
  var chronicConditions = ''.obs;
  var profileImagePath = ''.obs;

  void updateProfileImage(String newPath) {
    profileImagePath.value = newPath;
  }

  void updateProfile(
      String newName,
      String newEmail,
      String newPhone,
      String newLocation,
      String newGender,
      String newBloodType,
      String newAllergies,
      String newChronicConditions) {
    name.value = newName;
    email.value = newEmail;
    phone.value = newPhone;
    location.value = newLocation;
    gender.value = newGender;
    bloodType.value = newBloodType;
    allergies.value = newAllergies;
    chronicConditions.value = newChronicConditions;

    // Add logic here to save data to a database or API
    // For example, you could call an API to save the data
    print("Profile saved: Name: $newName, Image Path: $profileImagePath");
  }
}
