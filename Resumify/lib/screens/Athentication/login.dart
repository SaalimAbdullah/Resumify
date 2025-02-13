import 'package:flutter/material.dart';
import 'forget_password.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class ResumifyLogin extends StatefulWidget {
  const ResumifyLogin({Key? key}) : super(key: key);

  @override
  _ResumifyLoginState createState() => _ResumifyLoginState();
}

class _ResumifyLoginState extends State<ResumifyLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _rememberMe = false; // Variable to track the remember me checkbox
  bool _isLoading = false;  // Add a loading state for the login button

  // Function to validate the email format
  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  // Function to handle login
  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Input validation
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill all fields';
      });
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters long';
      });
      return;
    }

    setState(() {
      _isLoading = true; // Show loading state
    });


    try {
      // Firebase Authentication - Login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If the login is successful, save the remember me status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', _rememberMe); // Save login state

      setState(() {
        _errorMessage = null; // Clear error message on success
        _isLoading = false; // Stop loading
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );

      // Navigate to Home Page after login
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Login Failed';
        _isLoading = false; // Stop loading
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage ?? 'An error occurred')),
      );
    }
  }

  // Function to check if user is already logged in
  _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('loggedIn') ?? false;
    if (loggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check if the user is logged in when the app starts
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color(0xFF124C3C);

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
                        'assets/pictures/logo.png',
                        height: 180,
                      ),
                    ),
                    const SizedBox(height: 56),

                    const SizedBox(height: 2),
                    const Text(
                      'AI RESUME BUILDER',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
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
                padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Email/Phone Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _emailController, // For Email
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.grey),
                          hintText: 'Email or Phone',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Password Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _passwordController, // For Password
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.grey),
                          hintText: 'Password',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Remember Me Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!; // Update rememberMe state
                            });
                          },
                          activeColor: const Color(0xFF156045), // Green color for active state
                          checkColor: Colors.white, // White color for the check mark
                          side: const BorderSide(
                            color: Colors.grey, // Grey border for the checkbox
                            width: 2.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Rounded corners for checkbox
                          ),
                        ),
                        const Text('Remember me',
                        style: TextStyle(
                            color: Color(0xFF156045)
                        ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPassword()),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF156045),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _isLoading ? null : _login, // Disable button if loading
                      child: _isLoading
                          ? const CircularProgressIndicator() // Show loading indicator
                          : const Text(
                        'Login',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Error Message Display
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      SizedBox(height: 16.0),
                    ],
                    // Or Divider
                    const Text(
                      'or',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Create Account Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateAccount()),
                        );
                      },
                      child: const Text(
                        'Create an account',
                        style: TextStyle(fontSize: 16, color: Colors.black),
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
