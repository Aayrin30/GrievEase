import 'package:flutter/material.dart';
import 'feedback_questions.dart'; // Create this screen

class FacultyFeedbackScreen extends StatelessWidget {
  const FacultyFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faculty Feedback",
            style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: Colors.purple[900],
                shadows: const [
                  Shadow(
                    blurRadius: 2.0,
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    offset: Offset(1.0, 1.0),
                  )
                ])),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFacultyCard(
              context: context,
              facultyName: "Dr. Vishal Narvani",
              subject: "Flutter",
              color: Colors.primaries[0], // Use a color from the list
            ),
            _buildFacultyCard(
              context: context,
              facultyName: "Prof. Raihan Patel",
              subject: "CNS",
              color: Colors.primaries[1], // Use a different color
            ),
            _buildFacultyCard(
              context: context,
              facultyName: "Prof. Rachana Chaudhary",
              subject: "ADS",
              color: Colors.primaries[3], // Use another color
            ),
            _buildFacultyCard(
              context: context,
              facultyName: "Prof. Snehal Shukla",
              subject: "HPC",
              color: Colors.primaries[5], // Use another color
            ),
            // Add more faculty cards here
          ],
        ),
      ),
    );
  }

  Widget _buildFacultyCard({
    required BuildContext context,
    required String facultyName,
    required String subject,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell( // Make the card tappable
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => feedbackQuestions(
                  facultyName: facultyName,
                  subject: subject,
                )
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                facultyName,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subject,
                style: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20), // Increased space below subject
              Container( // Added a Container for size control
                height: 60, // Set desired height
                width: double.infinity, // Expand to full width
                decoration: BoxDecoration( // Rounded corners for the inner Container
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center, // Center the content
                child: Text("Additional Faculty Info"),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
