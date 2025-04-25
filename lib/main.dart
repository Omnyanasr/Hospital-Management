import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
//import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_managment_project/view/user_info/onboarding_screen_info.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:hospital_managment_project/controller/profile_controller.dart';
import 'package:hospital_managment_project/view/feedback_support_page.dart';
import 'package:hospital_managment_project/view/homepage.dart';
import 'package:hospital_managment_project/view/onboarding_screen.dart';
import 'package:hospital_managment_project/view/account/patient_profile_page.dart';
import 'package:hospital_managment_project/view/account/account_info.dart';
import 'package:hospital_managment_project/view/pages/symptom_chatbot_page.dart';
import 'package:hospital_managment_project/view/pages/blood_analysis_page.dart';
import 'package:hospital_managment_project/view/payment_screen.dart';
import 'package:hospital_managment_project/view/splash_screen.dart';
import 'package:hospital_managment_project/view/auth/login.dart';
import 'package:hospital_managment_project/view/auth/signup.dart';
import 'package:hospital_managment_project/view/pages/appointmentpage.dart';
import 'package:hospital_managment_project/view/about_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if onboarding is complete
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasCompletedOnboarding =
      prefs.getBool('hasCompletedOnboarding') ?? false;

  runApp(MyApp(hasCompletedOnboarding: hasCompletedOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasCompletedOnboarding;

  const MyApp({super.key, required this.hasCompletedOnboarding});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hospital App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 101, 154, 247)),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 101, 154, 247),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor:
              Color.fromARGB(255, 101, 154, 247), // Selected icon color
          unselectedItemColor: Colors.grey, // Unselected icon color
        ),
      ),
      initialRoute: '/splash',
      home: FutureBuilder<void>(
        future:
            _initializeProfileController(), // Initialize ProfileController asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); // Show splash screen until the controller is ready
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile'));
          } else {
            return _determineHomeScreen();
          }
        },
      ),
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => OnboardingScreen()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/signup', page: () => SignUp()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/appointment', page: () => AppointmentPage()),
        GetPage(name: '/profile', page: () => PatientProfilePage()),
        GetPage(name: '/symptom', page: () => SymptomCheckerPage()),
        GetPage(name: '/xray', page: () => BloodAnalysisPage()),
        GetPage(name: '/feedback', page: () => FeedbackSupportPage()),
        GetPage(name: '/payment', page: () => const PaymentScreen()),
        GetPage(name: '/onboarding_info', page: () => OnboardingScreenInfo()),
        GetPage(name: '/info', page: () => AccountInformationPage()),
        GetPage(name: '/about', page: () => AboutPage()),
      ],
    );
  }

  // Initialize the ProfileController asynchronously
  Future<void> _initializeProfileController() async {
    // You can check if the user is logged in and load profile data here
    await Get.putAsync(() async => ProfileController());
  }

  Widget _determineHomeScreen() {
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.emailVerified) {
      return hasCompletedOnboarding ? const HomePage() : OnboardingScreenInfo();
    } else {
      return Login();
    }
  }
}
