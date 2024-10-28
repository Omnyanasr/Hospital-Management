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

    // Here, you can also add logic to save the changes to a database or an API.
  }
}
