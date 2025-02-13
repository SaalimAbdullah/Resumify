import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'screens/Athentication/login.dart';
import 'screens/Athentication/signup.dart';
import 'screens/Athentication/forget_password.dart';
import 'screens/homeScreens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  Future<bool> getThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false; 
    return isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getThemePreference(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        } else {
          bool isDarkMode = snapshot.data ?? false; 
          return MaterialApp(
            title: 'Resumify',
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            
            theme: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                secondary: Colors.blueAccent, 
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blueAccent,
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.blue,
              ),
            ),
            
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.blueGrey,
                secondary: Colors.blueAccent,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blueGrey,
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.blueGrey,
              ),
            ),
            home: SplashScreen(), 
            routes: {
              '/login': (context) => ResumifyLogin(),
              '/signup': (context) => CreateAccount(),
              '/forgot-password': (context) => ForgotPassword(),
              '/home': (context) => HomePage(),
            },
          );
        }
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  
  _navigateToNextPage() {
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>
            ResumifyLogin()), 
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 3),
              child: Image.asset(
                'assets/pictures/Resumify.png', 
                width: 180, 
                height: 160,
              ),
            ),
            const SizedBox(height: 20),
            
            AnimatedSlide(
              offset: Offset(0, 0), 
              duration: const Duration(seconds: 2),
              child: const Text(
                'AI Resume Builder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2, 
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.6, 
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                
                backgroundColor: Colors.grey[300],
                
                minHeight: 6.0, 
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
