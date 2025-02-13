import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color(0xFF124C3C);

    // Controller for email input field
    final TextEditingController emailController = TextEditingController();

    // Function to handle password reset
    Future<void> resetPassword(BuildContext context) async {
      try {
        // Get the email entered by the user
        final email = emailController.text.trim();

        // Check if email is not empty
        if (email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your email address.')),
          );
          return;
        }

        // Call Firebase Auth to send a reset link
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent!')),
        );
      } catch (e) {
        // Handle errors (e.g., invalid email)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Half - Green Background
            Container(
              decoration: BoxDecoration(
                color: myColor,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Image.asset(
                        'assets/pictures/logo.png', // Replace with your image path
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Recover your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Bottom Half - White Background with Rounded Corners
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Please enter your registered email address. We will send you a password reset link.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    // Email Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: emailController, // Bind to the controller
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          hintText: 'Email Address',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Reset Password Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF156045),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => resetPassword(context), // Call the reset function
                      child: const Text(
                        'Send Reset Link',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Back to Login Button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Navigate back to Login Page
                      },
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
