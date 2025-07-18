import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/components/textformfield.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  // Controllers for input fields
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  // Form key
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  Login({super.key});

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the Google authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In aborted by user.');
      }

      // Obtain the auth details from the Google account
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Save or update user details in Firestore
      final user = userCredential.user;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          // Add user details if they don't exist in Firestore
          await userDoc.set({
            'username': user.displayName ?? 'Anonymous',
            'email': user.email ?? '',
            'photoUrl': user.photoURL ?? '',
            'createdAt': DateTime.now(),
            'hasCompletedOnboarding': false,
          });
        }
      }

      return userCredential;
    } catch (e) {
      // Handle errors
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }


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
                    'Sign In',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
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
                  // Sign In Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        try {
                          // Sign in with email and password
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email.text.trim(),
                            password: password.text.trim(),
                          );

                          // Check email verification
                          if (credential.user!.emailVerified) {
                            Get.offAllNamed('/home');
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please verify your email before logging in.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            Get.snackbar(
                              'Error',
                              'No user found for this email.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else if (e.code == 'wrong-password') {
                            Get.snackbar(
                              'Error',
                              'Incorrect password.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              'Something went wrong. Please try again.',
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
                      'Sign In',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("or"),
                  const SizedBox(height: 16),
                  // Google Sign In Button
                  ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/google.png',
                      height: 24,
                    ),
                    label: const Text('Sign in with Google'),
                    onPressed: () async {
                      try {
                        // Call the Google Sign-In function
                        final UserCredential userCredential =
                        await signInWithGoogle();

                        // Navigate to the home screen
                        Get.offAllNamed('/home');
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Google Sign-In failed. Please try again.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }

                    },
                  ),
                  const SizedBox(height: 16),
                  // Sign Up Option
                  Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.offNamed('/signup');
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
