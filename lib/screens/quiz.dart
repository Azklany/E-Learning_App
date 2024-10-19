import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = true;
  List<String?> _selectedAnswers = [];
  bool _isSubmitted = false; // Flag to track submission status
  Timer? _timer; // Timer for countdown
  int _remainingTime = 60; // Total time for the quiz in seconds

  @override
  void initState() {
    super.initState();
    fetchQuizData();
  }

  Future<void> fetchQuizData() async {
    final url = Uri.parse('https://quizapi.io/api/v1/questions?apiKey=qI2hfjSRAlAzJ3JYGZ3dKhdHI5jzTWNTUGeOqh5d&limit=10'); // Replace with your actual API key
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _questions = json.decode(response.body);
          _isLoading = false;
          // Initialize _selectedAnswers with null for each question
          _selectedAnswers = List.filled(_questions.length, null);
        });
        // Start the timer
        _startTimer();
      } else {
        throw Exception('Failed to load quizzes');
      }
    } catch (e) {
      print('Error fetching quiz data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _submitQuiz(); // Auto-submit when time is up
          timer.cancel(); // Stop the timer
        }
      });
    });
  }

  void _submitQuiz() {
    if (_isSubmitted) return; // Prevent multiple submissions

    // Cancel the timer if it's still running
    _timer?.cancel();

    int score = 0;

    // Evaluate selected answers against the correct answers
    for (int i = 0; i < _questions.length; i++) {
      final correctAnswers = _questions[i]['correct_answers'];
      String? selectedAnswer = _selectedAnswers[i];

      // Debugging: print the selected answer and correct answers
      print('Question ${i + 1}: Selected answer: $selectedAnswer');
      print('Correct answers: $correctAnswers');

      // Check if the selected answer matches the correct answer
      if (selectedAnswer != null && correctAnswers['${selectedAnswer}_correct'] == 'true') {
        score++;
      }
    }

    setState(() {
      _isSubmitted = true; // Set submission flag to true
    });

    // Show the result in a dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Results'),
          content: Text('Your score: $score/${_questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst); // Navigate back to the main screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Quiz'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _questions.isEmpty
          ? Center(child: Text('No quiz data available.'))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Q${_currentQuestionIndex + 1}: ${_questions[_currentQuestionIndex]['question']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left, // Align text to the left
            ),
          ),
          ..._questions[_currentQuestionIndex]['answers'].entries
              .where((entry) => entry.value != null)
              .map((entry) => ListTile(
            title: Text(entry.value),
            leading: Radio<String>(
              value: entry.key,
              groupValue: _selectedAnswers[_currentQuestionIndex],
              onChanged: (value) {
                setState(() {
                  _selectedAnswers[_currentQuestionIndex] = value;
                });
              },
            ),
          )),

          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Timer display
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Time remaining: ${_remainingTime}s',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                  // Question switching buttons
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 2,
                    ),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentQuestionIndex = index;
                          });
                        },
                        child: Text('Q${index + 1}', style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentQuestionIndex == index ? Colors.lightBlue : Colors.grey[300],
                        ),
                      );
                    },
                  ),
                  // Add space between the buttons
                  SizedBox(height: 16), // Adjust height as needed
                  // Submit button
                  ElevatedButton(
                    onPressed: _isSubmitted ? null : _submitQuiz, // Disable if submitted
                    child: Text(
                      'Submit Quiz',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
