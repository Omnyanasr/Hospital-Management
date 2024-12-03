import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/components/textformfield.dart';

class SignUp extends StatelessWidget {
  // Controllers for input fields
  final TextEditingController username = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  // Form key
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formState,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Username Field
                  CustomTextForm(
                    hintText: 'Enter your username',
                    mycontroller: username,
                    labelText: 'Username',
                    icon: const Icon(Icons.person_outline),
                    validator: (val) {
                      if (val == "") return "Can't be empty";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Email Field
                  CustomTextForm(
                    hintText: 'Enter your email',
                    mycontroller: email,
                    labelText: 'Email',
                    icon: const Icon(Icons.email_outlined),
                    validator: (val) {
                      if (val == "") return "Can't be empty";
                      if (!val!.contains('@')) return "Enter a valid email";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Phone Number Field
                  CustomTextForm(
                    hintText: 'Enter your phone number',
                    mycontroller: phoneNumber,
                    labelText: 'Phone Number',
                    icon: const Icon(Icons.phone_outlined),
                    validator: (val) {
                      if (val == "") return "Can't be empty";
                      if (val!.length < 10) return "Enter a valid phone number";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  CustomTextForm(
                    hintText: 'Enter your password',
                    mycontroller: password,
                    labelText: 'Password',
                    icon: const Icon(Icons.lock_outline),
                    obscureText: true,
                    validator: (val) {
                      if (val == "") return "Can't be empty";
                      if (val!.length < 6)
                        return "Password must be at least 6 characters";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Confirm Password Field
                  CustomTextForm(
                    hintText: 'Confirm your password',
                    mycontroller: confirmPassword,
                    labelText: 'Confirm Password',
                    icon: const Icon(Icons.lock_outline),
                    obscureText: true,
                    validator: (val) {
                      if (val == "") return "Can't be empty";
                      if (val != password.text) return "Passwords do not match";
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  // Sign Up Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        try {
                          // Create a user in Firebase Authentication
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.text.trim(),
                            password: password.text.trim(),
                          );

                          // Save user details to Firestore
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(credential.user!.uid)
                              .set({
                            'username': username.text.trim(),
                            'email': email.text.trim(),
                            'phone': phoneNumber.text.trim(),
                            'createdAt': DateTime.now(),
                            'hasCompletedOnboarding': false,
                          });

                          // Send email verification
                          await credential.user!.sendEmailVerification();

                          // Navigate to Onboarding Info
                          Get.offNamed('/onboarding_info');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            Get.snackbar(
                              'Weak Password',
                              'The password provided is too weak.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                            );
                          } else if (e.code == 'email-already-in-use') {
                            Get.snackbar(
                              'Email In Use',
                              'An account already exists for that email.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              'Something went wrong. Please try again later.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } catch (e) {
                          print('Error: $e');
                          Get.snackbar(
                            'Error',
                            'Something went wrong. Please try again later.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Already have an account?
                  Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.offNamed('/login');
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
