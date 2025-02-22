import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'myAppointmentsPage.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<String> availableDates = [];
  List<String> availableTimes = [];
  int selectedDateIndex = 0;
  int selectedTimeIndex = 0;
  String doctorId = "";

  @override
  void initState() {
    super.initState();
    fetchDoctorAvailability();
  }

  Future<void> fetchDoctorAvailability() async {
    final Map<String, dynamic> doctorData = Get.arguments ?? {};
    doctorId = doctorData['doctorsId'] ?? "";

    if (doctorId.isEmpty) {
      print("Error: doctorId is missing");
      return;
    }

    print("Fetching availability for Doctor ID: $doctorId");

    try {
      final docRef =
          FirebaseFirestore.instance.collection('doctors').doc(doctorId);
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final data = docSnap.data();
        print("Doctor Data: $data");

        if (data != null) {
          setState(() {
            availableDates = List<String>.from(data['availableDates'] ?? []);
            availableTimes = List<String>.from(data['availableTimes'] ?? []);
          });
        }
      } else {
        print("Error: Doctor document does not exist in Firestore");
      }
    } catch (e) {
      print("Error fetching availability: $e");
    }
  }

  void bookAppointment() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Error: No user logged in");
      return;
    }

    if (availableDates.isEmpty || availableTimes.isEmpty) {
      print("Error: No available dates or times selected.");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': doctorId, // Ensure doctorId is stored
        'doctorName': Get.arguments['doctorName'] ?? "Unknown Doctor",
        'specialty': Get.arguments['specialty'] ?? "Unknown Specialty",
        'date': availableDates[selectedDateIndex],
        'time': availableTimes[selectedTimeIndex],
        'photo': Get.arguments['photo'] ?? 'assets/doctor.png',
        'status': 'Upcoming',
        'patientId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Appointment successfully booked!");
      Get.to(MyAppointmentsPage());
    } catch (e) {
      print("Error booking appointment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> doctorData = Get.arguments ?? {};
    final String doctorName = doctorData['doctorName'] ?? "Unknown Doctor";
    final String specialty = doctorData['specialty'] ?? "Unknown Specialty";
    final String photo = doctorData['photo'] ?? 'assets/doctor.png';

    return Scaffold(
      appBar: AppBar(title: Text('Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctorName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(specialty),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Select Date", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            availableDates.isEmpty
                ? CircularProgressIndicator()
                : Container(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableDates.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDateIndex = index;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: selectedDateIndex == index
                                  ? Colors.blue
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                availableDates[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedDateIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 20),
            Text("Select Time", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            availableTimes.isEmpty
                ? CircularProgressIndicator()
                : Container(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableTimes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTimeIndex = index;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: selectedTimeIndex == index
                                  ? Colors.blue
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                availableTimes[index],
                                style: TextStyle(
                                  color: selectedTimeIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: bookAppointment,
              child: Text("Book an Appointment"),
            ),
          ],
        ),
      ),
    );
  }
}
