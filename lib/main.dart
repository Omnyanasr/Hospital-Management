import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/view/homepage.dart';
import 'package:hospital_managment_project/view/onboarding_screen.dart';
import 'package:hospital_managment_project/view/splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      ),
      initialRoute: '/splash', // Set splash as the initial route
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => OnboardingScreen()),
        GetPage(name: '/home', page: () => const HomePage()),
      ],
    );
  }
}
