import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital_managment_project/components/textformfield.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Login({super.key});

  Future signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("User canceled the sign-in");
        return; // The user canceled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.offNamed('/home');
    } catch (error) {
      print("Error signing in with Google: $error");
      Get.snackbar(
        'Error',
        'Failed to sign in with Google',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
                    'Sign in',
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
                    },
                  ),
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
                      }),
                  const SizedBox(height: 16),
                  // Remember me & Forgot Password Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      // Note: Removed Forgot Password for now
                      TextButton(
                        onPressed: () {
                          // Forgot password logic here
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sign in Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 50), // Full width button
                    ),
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        // Show "Logging in" message
                        Get.snackbar(
                          'Logging in',
                          'Please wait...',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 2),
                          showProgressIndicator: true,
                        );

                        // Capture the necessary data before async
                        String emailText = email.text;
                        String passwordText = password.text;

                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailText, password: passwordText);

                          // Navigate to the home screen after successful login
                          if (credential.user!.emailVerified) {
                            Get.offNamed('/home');
                          } else {
                            Get.snackbar(
                              'Error',
                              'Verify your email.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          // Debugging: Print the error code
                          print("Error Code: ${e.code}");

                          if (e.code == 'user-not-found') {
                            Get.snackbar(
                              'Error',
                              'No user found for that email.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else if (e.code == 'wrong-password') {
                            Get.snackbar(
                              'Error',
                              'Wrong password provided for that user.',
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
                          // General error handling
                          Get.snackbar(
                            'Error',
                            'Something went wrong. Please try again later.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } else {
                        print("Not Valid");
                      }
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("or"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60, // Adjust width as needed
                        height: 60, // Adjust height as needed
                        child: IconButton(
                          icon: Image.asset(
                              'assets/facebook.webp'), // Facebook icon
                          iconSize: 60, // Adjust icon size
                          onPressed: () {
                            // Facebook login logic here
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: IconButton(
                          icon: Image.asset('assets/google.png'), // Google icon
                          iconSize: 55,
                          onPressed: () {
                            signInWithGoogle();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sign up Option
                  Text.rich(
                    TextSpan(
                      text: "Don't have an Account? ",
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          // Sign up logic
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
