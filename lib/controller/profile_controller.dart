import 'package:get/get.dart';

class ProfileController extends GetxController {
  var name = 'Amjad Hussain'.obs;
  String get firstName => name.value.split(' ')[0];
  var email = 'example@email.com'.obs;
  var phone = '923448840525'.obs;
  var location = 'Gilgit'.obs;
  var gender = 'Male'.obs;
  var bloodType = 'AB'.obs;
  var allergies = 'None'.obs;
  var chronicConditions = 'None'.obs;
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
