import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:resumify/screens/Templates/Template.dart';
import 'package:resumify/screens/reume/buildresume.dart';
import 'package:resumify/screens/settings/setting.dart';
import 'dart:io';
import 'package:resumify/screens/homeScreens/home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generate Professional Resume',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey.shade100,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87), // Default text color
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey.shade900,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Adapts for dark mode
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.green,
          surface: Colors.grey,
        ),
      ),
      themeMode: ThemeMode.system, // Automatically adapts to device setting
      home: const ResumeFormPage(),
    );
  }
}

class ResumeFormPage extends StatefulWidget {
  const ResumeFormPage({Key? key}) : super(key: key);

  @override
  _ResumeFormPageState createState() => _ResumeFormPageState();
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  // Controllers for user input
  final _fullNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _addressController = TextEditingController();
  final _academicInfoController = TextEditingController();
  final _skillsController = TextEditingController();
  final _certificationExperienceController = TextEditingController();
  final _projectsController = TextEditingController();
  final _achievementsController = TextEditingController();

  String _response = '';
  bool _isLoading = false;

  final apiKey = 'GEMINI_API_KEY'; // Replace with your API key.

  Future<void> _generateResume() async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    // Structured request for AI to generate resume
    final resumeRequest = '''
    Generate a professional, fully written resume based on the following details. The resume should be recruiter-ready, fully detailed, and realistic. Do not include any placeholders like "[Specify a project or task...]" or "[Add details here]". Instead, fill in any missing details based on professional best practices and typical internship, project, and job experiences.

    Full Name: ${_fullNameController.text}
    Contact Number: ${_contactNumberController.text}
    Email: ${_emailController.text}
    LinkedIn Profile: ${_linkedinController.text.isNotEmpty
        ? _linkedinController.text
        : 'N/A'}
    Portfolio Link: ${_portfolioController.text.isNotEmpty
        ? _portfolioController.text
        : 'N/A'}
    Address: ${_addressController.text}

    Academic Information:
    ${_academicInfoController.text}

    Skills (both soft and technical skills):
    ${_skillsController.text}

    Certifications or Experience:
    ${_certificationExperienceController.text}

    Projects:
    ${_projectsController.text}

    Achievements:
    ${_achievementsController.text}

    Write in a professional tone, and ensure that each section has fully written content without requiring user input or edits.
    Subheadings should be enclosed in '*', except for 'Academic Information', 'Skills', 'Experience', 'Projects', 'Achievements' which should be enclosed in '**'. any bullet points should be written using '• ' rather than '*'.
    ''';
    final model = GenerativeModel(
      model: 'gemini-1.5-flash', // Specify the model you are using
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );


    final chat = model.startChat(history: []);
    final content = Content.text(resumeRequest);

    try {
      final response = await chat.sendMessage(content);

      setState(() {
        if (response is GenerateContentResponse) {
          _response = response.text ?? 'No text found in response.';
        } else {
          _response = 'Invalid response format.';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadAsPdf(String resumeText) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32.0), // Default margin
        build: (pw.Context context) {
          return [
            pw.Padding(
              padding: const pw.EdgeInsets.all(32.0), // Add padding around content
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: resumeText.split('\n').map((line) {
                  if (line.startsWith('**') && line.endsWith('**')) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 8.0, bottom: 4.0),
                      child: pw.Text(
                        line.replaceAll('*', '').replaceAll('–', '-'), // Remove asterisks
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  } else if (line.contains('*')) {
                    final parts = line.split('*');
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 16.0, bottom: 4.0),
                      child: pw.RichText(
                        text: pw.TextSpan(
                          children: parts.map((part) {
                            final isBold = part == parts[1];
                            return pw.TextSpan(
                              text: part.replaceAll('–', '-'),
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  } else if (line.trim().startsWith('•')) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 16.0, bottom: 4.0),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [

                          pw.Expanded(
                            child: pw.Bullet(
                              text: line.replaceFirst('\u2022 ', '').trim().replaceAll('–', '-'),

                              style: pw.TextStyle(
                                fontSize: 12, // Standard resume text size
                                fontWeight: pw.FontWeight.normal, // Keep text clean and readable
                              ),
                              bulletSize: 6.0, // standard bullet size?
                              bulletMargin: const pw.EdgeInsets.only(right: 8.0, top: 4), // Wider margin for cleaner alignment
                              bulletColor: PdfColors.black,

                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 2.0),
                      child: pw.Text(
                        line.replaceAll('–','-'),
                        style: pw.TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            )
          ];
        },
      ),
    );


    try {
      final directory = await getApplicationDocumentsDirectory(); // Use getDownloadsDirectory() for Downloads
      final filePath = '${directory.path}/resume.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved at $filePath')),
      );
      await OpenFile.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving PDF: $e'),
        ),
      );
    }
  }




  void _editResume() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResumeEditor(response: _response),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isOptional = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isOptional ? '$label (Optional)' : label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme
                .of(context)
                .colorScheme
                .onSurface
                .withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme
                .of(context)
                .colorScheme
                .primary,
          ),
        ),
        filled: true,
        fillColor: Theme
            .of(context)
            .colorScheme
            .surface
            .withOpacity(0.2),
        labelStyle: TextStyle(
          color: Theme
              .of(context)
              .textTheme
              .bodyMedium
              ?.color,
        ),
      ),
      style: TextStyle(
        color: Theme
            .of(context)
            .textTheme
            .bodyMedium
            ?.color,
      ),
    );
  }


  @override
  @override
  Widget build(BuildContext context) {
    final textColor = Theme
        .of(context)
        .textTheme
        .bodyMedium
        ?.color;
    final backgroundColor = Theme
        .of(context)
        .scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF156045),
        title: const Text(
            'Generate Professional Resume',
            style: TextStyle(
                fontSize: 18,
                color: Colors.white)
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField('Full Name', _fullNameController),
              const SizedBox(height: 10),
              _buildTextField('Contact Number', _contactNumberController),
              const SizedBox(height: 10),
              _buildTextField('Email', _emailController),
              const SizedBox(height: 10),
              _buildTextField(
                  'LinkedIn Profile', _linkedinController, isOptional: true),
              const SizedBox(height: 10),
              _buildTextField(
                  'Portfolio Link', _portfolioController, isOptional: true),
              const SizedBox(height: 10),
              _buildTextField('Address', _addressController),
              const SizedBox(height: 20),

              const Text(
                'Academic Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField('Academic Information', _academicInfoController,
                  isOptional: false),
              const SizedBox(height: 20),

              const Text(
                'Skills',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField('Skills', _skillsController, isOptional: false),
              const SizedBox(height: 20),

              const Text(
                'Certifications or Experience',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField('Certifications or Experience',
                  _certificationExperienceController, isOptional: false),
              const SizedBox(height: 20),

              const Text(
                'Projects',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                  'Projects', _projectsController, isOptional: true),
              const SizedBox(height: 20),

              const Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                  'Achievements', _achievementsController, isOptional: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateResume,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                    'Generate Resume', style: TextStyle(fontSize: 16,color: Color(0xFF156045))),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .surface, // Adaptable background for text area
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _response.split('\n').map((line) {
                      // Display each line of the response
                      return Text(
                        line,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _downloadAsPdf(_response),
                    icon: const Icon(Icons.download,color: Color(0xFF156045),),
                    label: const Text('Download as PDF',style: TextStyle(color: Color(0xFF156045))),
                  ),
                  ElevatedButton.icon(
                    onPressed: _editResume,
                    icon: const Icon(Icons.edit,color: Color(0xFF156045),),
                    label: const Text('Edit Resume',style: TextStyle(color: Color(0xFF156045))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }
}
class ResumeEditor extends StatelessWidget {
  final String response;

  const ResumeEditor({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Resume'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: TextEditingController(text: response),
                maxLines: 20,
                decoration: const InputDecoration(
                  labelText: 'Edit your Resume',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



Widget _buildBottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    selectedItemColor: const Color(0xFF156045),
    unselectedItemColor: Colors.grey,
    currentIndex: 1,
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
        //stay on resume builder page
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

