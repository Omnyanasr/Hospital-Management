import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_managment_project/controller/profile_controller.dart';
import 'package:hospital_managment_project/view/homepage.dart';
import 'package:hospital_managment_project/view/onboarding_screen.dart';
import 'package:hospital_managment_project/view/account/patient_profile_page.dart';
import 'package:hospital_managment_project/view/account/account_info.dart';
import 'package:hospital_managment_project/view/splash_screen.dart';
import 'package:hospital_managment_project/view/auth/login.dart';
import 'package:hospital_managment_project/view/auth/signup.dart';
import 'package:hospital_managment_project/view/pages/appointmentpage.dart'; // Import your appointment page


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(ProfileController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();

    // Listen to authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }

      // Update state with current user
      setState(() {
        _currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hospital App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 101, 154, 247)),
        //textTheme: GoogleFonts.openSansTextTheme(),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 101, 154, 247),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          // Set the color for selected and unselected icons and labels
          selectedItemColor:
              Color.fromARGB(255, 101, 154, 247), // Selected icon color
          unselectedItemColor: Colors.grey, // Unselected icon color
        ),
      ),
      initialRoute: '/splash',
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? HomePage()
          : Login(),
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => OnboardingScreen()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/signup', page: () => SignUp()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/appointment', page: () => AppointmentPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/profile', page: () => PatientProfilePage()),
        GetPage(
            name: '/info',
            page: () => AccountInformationPage()), // HomePage route
      ],
    );
  }
}
