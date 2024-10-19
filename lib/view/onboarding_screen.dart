import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController onboardingController =
      Get.put(OnboardingController());

  final List<String> images = [
    'images/slide1.png',
    'images/slide1.png',
    'images/slide1.png',
  ];

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                        height: 300, // Adjust image size as needed
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Slide ${index + 1}',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'This is the description for slide ${index + 1}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
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
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Only show "Skip" button on the first two slides
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
                  Obx(() {
                    return onboardingController.currentIndex.value == 2
                        ? ElevatedButton(
                            onPressed: () {
                              // Navigate to the home page
                              Get.offNamed('/home');
                            },
                            child: const Text('Get Started'),
                          )
                        : TextButton(
                            onPressed: () {
                              onboardingController.nextPage();
                            },
                            child: const Text('Next'),
                          );
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
