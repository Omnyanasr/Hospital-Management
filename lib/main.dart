import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/view/homepage.dart';
import 'package:hospital_managment_project/view/onboarding_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => OnboardingScreen()),
        GetPage(name: '/home', page: () => const HomePage()),
      ],
    );
  }
}
