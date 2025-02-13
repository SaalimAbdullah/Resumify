import 'package:flutter/material.dart';
import 'package:resumify/screens/homeScreens/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:resumify/screens/reume/buildresume.dart';
import 'package:resumify/screens/Templates/Template.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resumify/screens/Athentication/forget_password.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  _ResumifyAppState createState() => _ResumifyAppState();
}

class _ResumifyAppState extends State<settings> {
  bool isDarkMode = false;
  Future<void>? _themeLoader;

  @override
  void initState() {
    super.initState();
    _themeLoader = _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      prefs.setBool('isDarkMode', isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _themeLoader,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(color: Colors.white); // or a loading indicator
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Resumify',
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.light(
              primary: Color(0xff4c8479),
              onPrimary: Colors.white,
              secondary: Color(0xFF4c8479),
              onSecondary: Colors.black,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF4c8479),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(
              primary: Color(0xff4c8479),
              onPrimary: Colors.black,
              secondary: Color(0xff4c8479),
              onSecondary: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF4c8479),
            ),
          ),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: ProfilePage(
            isDarkMode: isDarkMode,
            toggleTheme: toggleTheme,
          ),
        );
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/pictures/Resumify.png'),
                  backgroundColor: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 30),
            SettingsSection(
              title: 'General Settings',
              dividerColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              sectionBackgroundColor: isDarkMode ? Color(0xff4c8479) : Colors.grey.shade200,
              titleColor: isDarkMode ? Colors.black : Colors.black,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: isDarkMode ? Color(0xff4c8479) : Colors.black,
                  ),
                  title: const Text('Mode'),
                  subtitle: const Text('Dark & Light'),
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      toggleTheme();
                    },
                  ),
                ),
                SettingsTile(
                  icon: Icons.key,
                  title: 'Change Password',
                  onTap: () { Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPassword()),
                  );},
                  isDarkMode: isDarkMode,
                ),
                SettingsTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsPage()),
                    );
                  },
                  isDarkMode: isDarkMode,
                ),

              ],
            ),
            SettingsSection(
              title: 'Information',
              dividerColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              sectionBackgroundColor: isDarkMode ? Color(0xff4c8479) : Colors.grey.shade200,
              titleColor: isDarkMode ? Colors.black : Colors.black,
              children: [
                SettingsTile(
                  icon: Icons.info,
                  title: 'About App',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutAppPage()),
                    );
                  },
                  isDarkMode: isDarkMode,
                ),
                SettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                    );
                  },
                  isDarkMode: isDarkMode,
                ),
                SettingsTile(
                  icon: Icons.gavel,
                  title: 'Terms and Conditions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TermsConditionsPage()),
                    );
                  },
                  isDarkMode: isDarkMode,
                ),
                SettingsTile(
                  icon: Icons.share,
                  title: 'Share This App',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShareAppPage()),
                    );
                  },
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color dividerColor;
  final Color sectionBackgroundColor;
  final Color titleColor;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.dividerColor = Colors.grey,
    required this.sectionBackgroundColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: sectionBackgroundColor,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: titleColor),
          ),
        ),
        Column(children: children),
        Divider(height: 1, color: dividerColor),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDarkMode;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode ? Color(0xff4c8479) : Colors.black,
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Resumify'),
        backgroundColor: const Color(0xFF4c8479),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About Resumify',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4c8479),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF4c8479)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Resumify is an AI-powered resume builder platform, designed to help job seekers create professional resumes effortlessly. '
                      'With custom templates and smart suggestions, Resumify is the easiest way to make a standout resume.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Features:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFeatureItem(
                icon: Icons.edit,
                title: 'Easy-to-use Interface',
                description:
                'A user-friendly interface that allows you to create resumes in just a few clicks.',
              ),
              _buildFeatureItem(
                icon: Icons.format_align_left,
                title: 'Customizable Templates',
                description:
                'Choose from a variety of professionally designed templates that you can customize to your needs.',
              ),
              _buildFeatureItem(
                icon: Icons.lightbulb_outline,
                title: 'AI-powered Suggestions',
                description:
                'Get smart suggestions on how to improve your resume based on your job role.',
              ),
              _buildFeatureItem(
                icon: Icons.preview,
                title: 'Real-time Resume Previews',
                description:
                'See real-time previews of your resume as you make edits.',
              ),
              _buildFeatureItem(
                icon: Icons.file_download,
                title: 'Download in Various Formats',
                description:
                'Download your resume in multiple formats like PDF, Word, and more.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF4c8479),
              size: 30,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  // Optional: Add a timestamp or any other content if necessary
                  // Text(
                  //   'Added recently',
                  //   style: const TextStyle(fontSize: 14, color: Colors.black38),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class TermsConditionsPage extends StatefulWidget {
  const TermsConditionsPage({super.key});

  @override
  _TermsConditionsPageState createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        backgroundColor: const Color(0xFF4c8479),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4c8479),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'By using the Resumify app, you agree to the following terms and conditions:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              _buildTermsSection(
                title: '1. Acceptance of Terms',
                content:
                'By accessing or using Resumify, you agree to abide by these Terms and Conditions and our Privacy Policy.',
              ),
              _buildTermsSection(
                title: '2. User Responsibilities',
                content:
                'You are responsible for maintaining the confidentiality of your account and for all activities under your account.',
              ),
              _buildTermsSection(
                title: '3. Prohibited Activities',
                content:
                'You must not use the app for illegal activities, including but not limited to fraud, spamming, or violating intellectual property rights.',
              ),
              _buildTermsSection(
                title: '4. Modifications to Terms',
                content:
                'We reserve the right to modify these terms at any time. Any changes will be reflected on this page.',
              ),
              _buildTermsSection(
                title: '5. Limitation of Liability',
                content:
                'Resumify will not be held liable for any damages resulting from the use or inability to use the app.',
              ),
              const SizedBox(height: 20),
              const Text(
                'By continuing to use Resumify, you accept and agree to these terms and conditions.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF4c8479)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: const Color(0xFF4c8479),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4c8479),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Resumify takes your privacy seriously. We value your trust and strive to protect the privacy of your personal data.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              _buildPolicySection(
                title: '1. Information Collection',
                content:
                'We collect minimal information such as your name and email address when you sign up or use certain features.',
              ),
              _buildPolicySection(
                title: '2. Data Usage',
                content:
                'The information we collect is used to enhance your experience, such as improving our resume services and providing better features.',
              ),
              _buildPolicySection(
                title: '3. Data Sharing',
                content:
                'We do not share your data with third parties unless required by law or for essential service delivery.',
              ),
              _buildPolicySection(
                title: '4. Data Security',
                content:
                'We implement industry-standard security measures to protect your data from unauthorized access or breaches.',
              ),
              _buildPolicySection(
                title: '5. User Rights',
                content:
                'You have the right to access, modify, or delete your data at any time through your account settings.',
              ),
              const SizedBox(height: 20),
              const Text(
                'By using Resumify, you agree to our privacy practices. If you have any questions, feel free to contact us.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF4c8479),
              size: 30,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareAppPage extends StatelessWidget {
  const ShareAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Resumify'),
        backgroundColor: const Color(0xFF4c8479),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Share Resumify with your friends and help them build their dream resumes!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                shareApp();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4c8479),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'Share Now',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> shareApp() async {
    final Uri url = Uri.parse('https://www.google.com'); // Share app link here
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }
}
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF4c8479),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4c8479),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF4c8479)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'This section will display all the notifications from the Resumify app. Stay updated with the latest announcements and updates related to your profile and resumes.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent Notifications:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildNotificationItem(
                title: 'New Feature Released',
                description: 'We have added new customizable templates for your resumes.',
                timestamp: '2 hours ago',
              ),
              _buildNotificationItem(
                title: 'Update Available',
                description: 'There is a new update available for the app. Please update to the latest version.',
                timestamp: '1 day ago',
              ),
              _buildNotificationItem(
                title: 'Maintenance Downtime',
                description: 'The app will be undergoing maintenance from 2 AM to 4 AM.',
                timestamp: '3 days ago',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({required String title, required String description, required String timestamp}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications,
                  color: Color(0xFF4c8479),
                  size: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        timestamp,
                        style: const TextStyle(fontSize: 14, color: Colors.black38),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
        );
    }
}


Widget _buildBottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    selectedItemColor: const Color(0xFF156045),
    unselectedItemColor: Colors.grey,
    currentIndex: 3, // Set to Templates index
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
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
        //stay on settings page
      }
    },
  );
}

