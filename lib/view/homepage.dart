import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:hospital_managment_project/components/appointment_card.dart';
import 'package:hospital_managment_project/components/doctors_available.dart';
import 'package:hospital_managment_project/components/treatment_row.dart';
import 'package:hospital_managment_project/controller/profile_controller.dart';
import 'package:hospital_managment_project/view/account/patient_profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Current index of the BottomNavigationBar
  final List<Widget> _pages = [
    HomeScreen(),
    Container(), // Placeholder for Chatbot dropdown
    PatientProfilePage(),
  ];

  // Method to display the chatbot options dropdown
  void _showChatbotOptions(BuildContext context) {
    showMenu(
      context: context,
      position:
          const RelativeRect.fromLTRB(50, 600, 50, 0), // Adjust for positioning
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.medical_services, color: Colors.blue),
            title: const Text("Symptom Checker"),
            onTap: () {
              Navigator.pop(context); // Close the menu
              Get.toNamed('/symptom');
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.image_search, color: Colors.blue),
            title: const Text("X-ray Analyzer"),
            onTap: () {
              Navigator.pop(context); // Close the menu
              Get.toNamed('/xray');
            },
          ),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // Show the chatbot options when the chatbot item is tapped
      _showChatbotOptions(context);
    } else {
      setState(() {
        _currentIndex = index; // Update current index for other pages
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 1
          ? _pages[0]
          : _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => _showChatbotOptions(context), // Show menu on tap
              child: const Icon(Icons.chat),
            ),
            label: "Chatbot",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "My profile",
          ),
        ],
        currentIndex: _currentIndex, // Set current index
        onTap: _onItemTapped, // Handle item taps
      ),
    );
  }
}

// HomeScreen widget to display the home content
class HomeScreen extends StatelessWidget {
  final ProfileController profileController =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Hello, ${profileController.name.value.split(' ')[0]} 👋',
              style: const TextStyle(
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
                  //GoogleSignIn googleSignIn = GoogleSignIn();
                  //await googleSignIn.disconnect();
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
                    image: AssetImage('assets/homebg.jpg'),
                    fit: BoxFit.cover,
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
                              Get.toNamed('/symptom');
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
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/xray');
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
    );
  }
}
