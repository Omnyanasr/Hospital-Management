class ProfileModel {
  String? gender;
  int? age;
  double? weight;
  List<String> allergies = [];
  List<String> chronicDiseases = [];
  List<String> surgeries = [];

  ProfileModel();

  Map<String, dynamic> toJson() => {
        'gender': gender,
        'age': age,
        'weight': weight,
        'allergies': allergies,
        'chronicDiseases': chronicDiseases,
        'surgeries': surgeries,
      };
}
