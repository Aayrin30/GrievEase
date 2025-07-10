import 'package:flutter/material.dart';

class feedbackQuestions extends StatefulWidget {
  final String facultyName;
  final String subject;

  const feedbackQuestions({super.key, required this.facultyName, required this.subject});

  @override
  State<feedbackQuestions> createState() => _feedbackQuestionsState();
}

class _feedbackQuestionsState extends State<feedbackQuestions> {
  // Store the selected options for each question
  List<int?> selectedOptions = List.generate(5, (index) => null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback Questions"),
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align questions to the left
          children: [
            Center(
              child: Text(
                "Feedback for ${widget.facultyName} (${widget.subject})",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            // Generate 5 questions
            for (int i = 0; i < 5; i++) ...[
              Text("Question ${i + 1}: How satisfied were you with the faculty's teaching?",
                style: TextStyle(
                  fontSize: 16
                ),
              ), // Example question
              SizedBox(height: 5),
              _buildRadioOptions(i), // Build radio options for each question
              SizedBox(height: 5),
            ],
            Center( // Center the button
              child: ElevatedButton(
                onPressed: () {
                  // Handle submission (e.g., send feedback to server)
                  print("Selected Options: $selectedOptions");
                },
                child: const Text("Submit Feedback"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOptions(int questionIndex) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.grey,
        radioTheme: RadioThemeData(
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      child: Column(
        children: [
          RadioListTile<int>(
            title: const Text('Worst'),
            value: 0,
            groupValue: selectedOptions[questionIndex],
            onChanged: (int? value) {
              setState(() {
                selectedOptions[questionIndex] = value;
              });
            },
          ),
          RadioListTile<int>(
            title: const Text('Satisfactory'),
            value: 1,
            groupValue: selectedOptions[questionIndex],
            onChanged: (int? value) {
              setState(() {
                selectedOptions[questionIndex] = value;
              });
            },
          ),
          RadioListTile<int>(
            title: const Text('Good'),
            value: 2,
            groupValue: selectedOptions[questionIndex],
            onChanged: (int? value) {
              setState(() {
                selectedOptions[questionIndex] = value;
              });
            },
          ),
          RadioListTile<int>(
            title: const Text('Excellent'),
            value: 3,
            groupValue: selectedOptions[questionIndex],
            onChanged: (int? value) {
              setState(() {
                selectedOptions[questionIndex] = value;
              });
            },
          ),        ],
      ),
    );
  }
}