import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hospital_managment_project/components/appointment_card.dart';
import 'package:hospital_managment_project/components/doctors_available.dart';
import 'package:hospital_managment_project/components/treatment_row.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Hello, John 👋',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                onPressed: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Get.offNamed('/login');
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chatbot section with image and vertical buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    //opacity: 30,
                    image: AssetImage(
                        'assets/homebg.jpg'), // Set your background image here
                    fit: BoxFit
                        .cover, // Adjusts the image to cover the entire container
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Column with Chatbot options
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chatbot Services",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the symptom chatbot page
                              //Get.toNamed('/symptom-chatbot');
                            },
                            child: Card(
                              color: Colors.blue[100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.medical_services,
                                        size: 15, color: Colors.blue[800]),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "Symptom Checker",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the x-ray chatbot page
                              //Get.toNamed('/xray-chatbot');
                            },
                            child: Card(
                              color: Colors.blue[100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.image_search,
                                        size: 15, color: Colors.blue[800]),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "X-ray Analyzer",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/robothp.png',
                      height: 200,
                      width: 150,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Next appointments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              AppointmentCard(),
              const SizedBox(height: 20),
              const Text("Treatment for today",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TreatmentRow(),
              const SizedBox(height: 20),
              const Text("Doctors Available",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DoctorsAvailable(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 101, 154, 247),
              ),
              child: const Icon(Icons.chat, color: Colors.white),
            ),
            label: "Chatbot",
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.medical_services), label: "Med card"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "My profile"),
        ],
      ),
    );
  }
}
