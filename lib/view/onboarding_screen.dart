import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController onboardingController =
      Get.put(OnboardingController());

  final List<String> images = [
    'assets/slide11.png',
    'assets/slide2.png',
    'assets/slide32.png',
  ];

  final List<String> titles = [
    'Welcome to Your \nPersonalized Health Companion',
    'AI-Powered Health Assistant',
    'Manage Your Appointments and Records',
  ];

  final List<String> descriptions = [
    'Manage your healthcare effortlessly with us. Stay on top of appointments, access your medical records, and get the care you need—all in one app.',
    'Our smart chatbot helps with booking appointments, answering health-related questions, and providing medication instructions.',
    'Schedule appointments, view test results, and track your health with real-time notifications.',
  ];

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Flexible(
              child: PageView.builder(
                controller: onboardingController.pageController,
                onPageChanged: (index) {
                  onboardingController.currentIndex.value = index;
                },
                itemCount: images.length, // Number of slides
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        images[index],
                        height: 205, // Adjust image size as needed
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        titles[index], // Dynamic title
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          descriptions[index], // Dynamic description
                          style: const TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length, // Number of dots
                (index) => Obx(() {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    width: onboardingController.currentIndex.value == index
                        ? 12
                        : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: onboardingController.currentIndex.value == index
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Only show "Skip" button on the first two slides
                  Obx(() {
                    return onboardingController.currentIndex.value == 2
                        ? SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the home page
                                Get.offNamed('/login');
                              },
                              child: const Text('Get Started'),
                            ),
                          )
                        : SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () {
                                onboardingController.nextPage();
                              },
                              child: const Text(
                                'Next',
                              ),
                            ),
                          );
                  }),
                  Obx(() {
                    return onboardingController.currentIndex.value < 2
                        ? TextButton(
                            onPressed: () {
                              onboardingController.skip();
                            },
                            child: const Text('Skip'),
                          )
                        : const SizedBox(); // Empty widget on the last slide
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
