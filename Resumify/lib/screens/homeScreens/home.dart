import 'package:flutter/material.dart';
import 'package:resumify/screens/Athentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resumify/screens/Templates/Template.dart';
import 'package:resumify/screens/Templates/TemplateFD.dart';
import 'package:resumify/screens/Templates/TemplateSD.dart';
import 'package:resumify/screens/Templates/TemplateGD.dart';
import 'package:resumify/screens/reume/buildresume.dart';
import 'package:resumify/screens/settings/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Resume Templates", "Pick the best fit for your career goals."),
              const SizedBox(height: 20),
              _buildTemplateCarousel(context),
              const SizedBox(height: 30),
              _buildSectionHeader("Quick Actions", "Easily create or customize your resume."),
              const SizedBox(height: 20),
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF156045),
      title: const Text(
        'RESUMIFY',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              _showProfileMenu(context);
            },
            child: Image.asset(
              'assets/pictures/Resumify.png',
              width: 50,
              height:50,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
      elevation: 0,
    );
  }

  void _showProfileMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [


                const Divider(),
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: const Text('Manage Your Account'),
                  onTap: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const settings()),);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    try {
                      // Sign out from Firebase
                      await FirebaseAuth.instance.signOut();

                      // Optionally clear session data (e.g., user preferences)
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();

                      // Navigate to the login page and remove all previous screens from the stack
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const ResumifyLogin()), // Replace with your login page widget
                            (route) => false, // This will remove all the previous routes
                      );
                    } catch (e) {
                      print('Error logging out: $e'); // Handle error if any
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC6AA58),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  Widget _buildTemplateCard(
      BuildContext context, String title, String imagePath, Widget destinationPage) {

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        },
        child: Container(
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTemplateCarousel(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTemplateCard(
            context,
            "Fashion Designer",
            "assets/pictures/fd.png",
            ResumeTemplatePageFD(),
          ),
          _buildTemplateCard(
            context,
            "Software Developer",
            "assets/pictures/sd.jpg",
            ResumeTemplatePageSD(),
          ),
          _buildTemplateCard(
            context,
            "Graphic Designer",
            "assets/pictures/gd.jpg",
            ResumeTemplatePageGD(),
          ),
        ],
      ),
    );
  }


  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        _buildActionCard(
          context,
          title: "Customize With AI",
          icon: Icons.add_circle_outline,
          color: const Color(0xFF156045),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ResumeFormPage()));
          },
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          context,
          title: "Explore Templates",
          icon: Icons.folder_open,
          color: const Color(0xFFC6AA58),
          onPressed: () {
            // Navigate to Templates Page

            Navigator.push(context, MaterialPageRoute(builder: (context) => ResumeTemplatePage()));
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required String title, required IconData icon, required Color color, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: const Color(0xFF156045),
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_drive_file),
          label: 'Templates',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Settings',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          // Stay on Home Page
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResumeFormPage()),
          );
        } else if (index == 2) {
          // Navigate to Templates Page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResumeTemplatePage()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const settings()),
          );
        }
      },
    );
  }
}
