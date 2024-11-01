import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/components/textformfield.dart';

class SignUp extends StatelessWidget {
  TextEditingController username = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

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
                  // Email TextField
                  CustomTextForm(
                      hintText: 'Enter your email',
                      mycontroller: email,
                      labelText: 'Email',
                      icon: const Icon(Icons.email_outlined),
                      validator: (val) {
                        if (val == "") {
                          return "Can't be Empty";
                        }
                        return null;
                      }),
                  const SizedBox(height: 16),
                  // Password TextField
                  CustomTextForm(
                      hintText: 'Enter your password',
                      mycontroller: password,
                      labelText: 'Password',
                      icon: const Icon(Icons.lock_outline),
                      suffixIcon: const Icon(Icons.visibility_off),
                      obscureText: true,
                      validator: (val) {
                        if (val == "") {
                          return "Can't be Empty";
                        }
                        return null;
                      }),
                  const SizedBox(height: 16),
                  // Confirm Password TextField
                  CustomTextForm(
                      hintText: 'Confirm your password',
                      mycontroller: confirmPassword,
                      labelText: 'Confirm Password',
                      icon: const Icon(Icons.lock_outline),
                      suffixIcon: const Icon(Icons.visibility_off),
                      obscureText: true,
                      validator: (val) {
                        if (val == "") {
                          return "Can't be Empty";
                        }
                        return null;
                      }),
                  const SizedBox(height: 16),
                  // Phone Number TextField
                  CustomTextForm(
                      hintText: 'Enter your phone number',
                      mycontroller: phoneNumber,
                      labelText: 'Phone Number',
                      icon: const Icon(Icons.phone_outlined),
                      validator: (val) {
                        if (val == "") {
                          return "Can't be Empty";
                        }
                        return null;
                      }),
                  const SizedBox(height: 30),
                  // Sign up Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 50), // Full width button
                    ),
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        if (password.text != confirmPassword.text) {
                          Get.snackbar(
                            'Error',
                            'Passwords do not match.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                          FirebaseAuth.instance.currentUser!
                              .sendEmailVerification();
                          // Navigate to the login screen after successful sign-up
                          Get.offNamed('/login');

                          Get.snackbar(
                            'Success',
                            'Account created successfully.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
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
                              'Email Exists',
                              'The account already exists for that email.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange,
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
                      'Sign up',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sign in Option
                  Text.rich(
                    TextSpan(
                      text: "Already have an Account? ",
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          // Navigate to Sign in page
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
