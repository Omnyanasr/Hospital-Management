import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:hospital_managment_project/components/appointment_card.dart';
import 'package:hospital_managment_project/components/doctors_available.dart';
import 'package:hospital_managment_project/components/treatment_row.dart';
import 'package:hospital_managment_project/controller/profile_controller.dart';
import 'package:hospital_managment_project/view/account/patient_profile_page.dart';
import 'package:hospital_managment_project/view/pages/myAppointmentsPage.dart';
import 'package:intl/intl.dart';

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
            title: const Text(
              "Symptom Checker",
              style: TextStyle(fontSize: 12),
            ),
            onTap: () {
              Navigator.pop(context); // Close the menu
              Get.toNamed('/symptom');
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.image_search, color: Colors.blue),
            title: const Text(
              "Blood Test",
              style: TextStyle(fontSize: 12),
            ),
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
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileController profileController =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());
  Future<Map<String, dynamic>?> _fetchSoonestAppointment() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('patientId', isEqualTo: userId)
        .where('status', isEqualTo: 'Upcoming')
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    List<Map<String, dynamic>> appointments = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    DateTime? parseAppointmentDate(Map<String, dynamic> appointment) {
      try {
        String dateStr = cleanString(appointment['date']);
        String timeStr = cleanString(appointment['time']);

        debugUnicode("Cleaned Time String", timeStr); // Debugging

        // Ensure `AM/PM` is properly formatted and remove any stray spaces
        timeStr = timeStr.replaceAll(RegExp(r'\s+'), ' ').trim();

        // Validate the time format explicitly (Optional)
        if (!timeStr.contains(RegExp(r'(AM|PM|am|pm)$'))) {
          throw FormatException("Invalid time format: $timeStr");
        }

        // Parse date and time
        DateTime parsedDate = DateFormat("MMMM d").parse(dateStr);
        DateTime parsedTime = DateFormat("h:mm a").parse(timeStr); // Fix format

        return DateTime(DateTime.now().year, parsedDate.month, parsedDate.day,
            parsedTime.hour, parsedTime.minute);
      } catch (e) {
        print("❌ Error parsing appointment date/time: $e");
        print("➡ Raw Date String: '${appointment['date']}'");
        print("➡ Raw Time String: '${appointment['time']}'");
        return null;
      }
    }

    appointments = appointments
        .where((appt) => parseAppointmentDate(appt) != null)
        .toList();
    appointments.sort(
        (a, b) => parseAppointmentDate(a)!.compareTo(parseAppointmentDate(b)!));

    return appointments.isNotEmpty ? appointments.first : null;
  }

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
            title: Obx(() {
              final firstName = profileController.name.value.split(' ')[0];
              return Text(
                'Hello, $firstName 👋',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                onPressed: () async {
                  // Google Sign-Out logic
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  await googleSignIn.signOut(); // Sign out from Google
                  await FirebaseAuth.instance
                      .signOut(); // Sign out from Firebase

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
                width: double.infinity, // Ensures full width
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
                                      "Blood Test",
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.3, // Responsive width
                      child: Image.asset(
                        'assets/robothp.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Next appointments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              FutureBuilder<Map<String, dynamic>?>(
                future: _fetchSoonestAppointment(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("No upcoming appointments."),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(
                                '/appointment'); // Navigate to appointments page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("View All Appointments"),
                        ),
                      ],
                    );
                  }

                  var appointment = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppointmentCard(
                        doctorName: appointment['doctorName'],
                        specialty: appointment['specialty'],
                        status: appointment['status'],
                        time: appointment['time'],
                        date: appointment['date'],
                        photo:
                            appointment['photo'] ?? 'assets/default_doctor.png',
                        showCancelButton: false, // Keep it if needed
                      ),
                      Align(
                        alignment: Alignment.centerRight, // Align to the right
                        child: TextButton(
                          onPressed: () {
                            Get.to(
                                MyAppointmentsPage()); // Navigate to appointments page
                          },
                          child: const Text(
                            "View All Appointments",
                            style: TextStyle(
                              color: Colors.blue, // Make text blue
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 8),
              const Text("Your Treatments",
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

  void debugUnicode(String label, String input) {
    print("🔍 Debugging $label character by character:");
    for (int i = 0; i < input.length; i++) {
      print(
          "🔹 Char ${i + 1}: '${input[i]}' (Unicode: ${input.codeUnitAt(i)})");
    }
  }

  String cleanString(String input) {
    return input
        .replaceAll(RegExp(r'[\u00A0\u2007\u202F\u2009\u200A\u200B\uFEFF]'),
            ' ') // Remove Unicode spaces
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize spaces
        .trim();
  }
}
