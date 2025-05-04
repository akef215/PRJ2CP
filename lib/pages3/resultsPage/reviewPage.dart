import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/appbar.dart';
import '../../pages1/logMobile.dart';

class QuizReviewPage extends StatefulWidget {
  final String quizId;

  const QuizReviewPage({Key? key, required this.quizId}) : super(key: key);

  @override
  _QuizReviewPageState createState() => _QuizReviewPageState();
}

class _QuizReviewPageState extends State<QuizReviewPage> {
  late Future<Map<String, dynamic>> _reviewDataFuture;
  int _currentQuestionIndex = 0;
  List<_Question> _questions = [];
  Map<int, List<int>?> _userAnswers = {}; // questionId -> selected choiceId
  Map<int, List<String>> _correctAnswers = {}; // questionId -> correct answer
  bool _isLoading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _reviewDataFuture = _fetchReviewData();
  }

  Future<Map<String, dynamic>> _fetchReviewData() async {
    try {
      final quizDetailsResponse = await http.get(
        Uri.parse(path + '/quizzes/quizzes/' + widget.quizId + '/details_more'),
      );
      final correctionResponse = await http.get(
        Uri.parse(path + '/quizzes/correction/' + widget.quizId),
      );
      final userAnswersResponse = await _fetchUserAnswersForQuiz(widget.quizId);

      if (quizDetailsResponse.statusCode == 200 && correctionResponse.statusCode == 200 && userAnswersResponse != null) {
        final detailsData = json.decode(quizDetailsResponse.body);
        final correctionsData = json.decode(correctionResponse.body) as List;
        final Map<int, List<int>?> userAnswersData = userAnswersResponse;

        _questions = (detailsData['questions'] as List)
            .map((q) => _Question.fromJson(q as Map<String, dynamic>))
            .toList();

        // Process correction data into a map of questionId -> list of correct answers
        Map<int, List<String>> correctAnswersMap = {};
        for (var correction in correctionsData) {
          final int questionId = correction['question_id'] as int;
          final String correctAnswer = correction['answer'] as String;
          correctAnswersMap.putIfAbsent(questionId, () => []);
          correctAnswersMap[questionId]!.add(correctAnswer);
        }
        _correctAnswers = correctAnswersMap;

        _userAnswers = userAnswersData;

        _isLoading = false;
        setState(() {});
        return {}; // Return an empty map as the data is stored in state
      } else {
        _error = true;
        _isLoading = false;
        setState(() {});
        throw Exception('Failed to load review data');
      }
    } catch (e) {
      _error = true;
      _isLoading = false;
      setState(() {});
      print('Error fetching review data: $e');
      return {};
    }
  }

  Future<Map<int, List<int>?>?> _fetchUserAnswersForQuiz(String quizId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentId = prefs.getString('studentId');

    if (studentId == null) {
      print('Error: Student ID not found.');
      return null;
    }

    final Uri url = Uri.parse(
        '$path/quizzes/answers?student_id=$studentId'); // Fetch ALL answers

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> allAnswers = json.decode(response.body) as List;

        // Filter for answers belonging to the specific quiz ID
        final List<dynamic> currentQuizAnswers = allAnswers
            .where((answer) => answer['quiz_id'] == int.parse(quizId))
            .toList();

        // Format the filtered answers into a map of questionId -> list of selected choiceIds
        Map<int, List<int>?> formattedAnswers = {};
        for (var answer in currentQuizAnswers) {
          final int questionId = answer['question_id'] as int;
          final int choiceId = answer['choice_id'] as int;
          formattedAnswers.putIfAbsent(questionId, () => []);
          formattedAnswers[questionId]!.add(choiceId);
        }

        print('User Answers for Quiz $quizId: $formattedAnswers');
        return formattedAnswers;
      } else {
        print('Failed to fetch user answers: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user answers: $e');
      return null;
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  bool _isChoiceSelected(int choiceId) {
    final currentQuestionId = _questions[_currentQuestionIndex].questionId;
    return _userAnswers[currentQuestionId]?.contains(choiceId) ?? false;
  }


  bool _isChoiceCorrect(int choiceId) {
    final currentQuestionId = _questions[_currentQuestionIndex].questionId;
    final List<String>? correctAnswers = _correctAnswers[currentQuestionId];
    final selectedAnswer = _questions[_currentQuestionIndex].choices
        .firstWhere(
          (c) => c.choiceId == choiceId,
      orElse: () => _Choice(choiceId: -1, answer: ''),
    )
        .answer
        .trim()
        .toLowerCase();

    return correctAnswers?.any((correctAnswer) =>
    correctAnswer.trim()
        .toLowerCase() == selectedAnswer) ?? false;
  }

  List<String>? _getCorrectAnswerList() {
    final currentQuestionId = _questions[_currentQuestionIndex].questionId;
    return _correctAnswers[currentQuestionId];
  }

  Widget _buildAnswerOption(BuildContext context, _Choice choice) {
    final isSelected = _isChoiceSelected(choice.choiceId);
    final wasUserCorrect = _isChoiceCorrect(choice.choiceId);
    final correctAnswersList = _correctAnswers[_questions[_currentQuestionIndex].questionId] ?? [];
    final isACorrectChoice = correctAnswersList.any((correctAnswer) => correctAnswer.trim().toLowerCase() == choice.answer.trim().toLowerCase());

    IconData icon = Icons.radio_button_unchecked;
    Color textColor = Colors.white;
    Color iconColor = Colors.grey;

    if (isSelected) {
      icon = wasUserCorrect ? Icons.check_circle : Icons.cancel;
      iconColor = wasUserCorrect ? Colors.green : Colors.red;
      textColor = Colors.white; // Keep text white on selection
    } else if (!isSelected && isACorrectChoice) {
      icon = Icons.check_circle_outline;
      iconColor = Colors.green;
      textColor = Colors.green; // Highlight correct but unselected
    } else {
      textColor = Colors.white; // Default text color
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 25),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              choice.answer,
              style: TextStyle(color: textColor, fontSize: 15, fontFamily: "MontserratSemi"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final currentQuestion = _questions.isNotEmpty ? _questions[_currentQuestionIndex] : null;
    final choices = currentQuestion?.choices ?? [];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Custom_appBar().buildAppBar(context, "Quiz Review", true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFC8E5FF),
              Color(0xFFEEF7FF),
            ],
          ),
        ),
        width: screenWidth,
        height: screenHeight,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error
            ? const Center(child: Text('Failed to load quiz review data.'))
            : _questions.isEmpty
            ? const Center(child: Text('No questions to review.'))
            : Stack( // Use Stack to position the navigation at the bottom
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.1), // Adjust bottom padding for navigation
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + screenHeight * 0.2),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.11,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.07,
                            vertical: screenHeight * 0.05,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff21334E),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  currentQuestion?.statement ?? 'Loading...',
                                  style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[100], fontFamily: "MontserratSemi"),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              ...choices.map((choice) => _buildAnswerOption(context, choice)).toList(),
                              SizedBox(height: screenHeight * 0.04),
                              // Removed the "Back" and "Next" Buttons here
                            ],
                          ),
                        ),
                        Positioned(
                          top: -screenHeight * 0.065,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: screenWidth * 0.2,
                                height: screenHeight * 0.095,
                                decoration: const BoxDecoration(
                                  color: Color(0xffeef7ff),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    'Review',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: const Color(0xff21334E),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02), // Add some spacing below the answer box
                  ],
                ),
              ),
            ),
            /*-----------------NAVIGATION ARROW----------------------*/
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 15, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // BACK BUTTON
                    GestureDetector(
                      onTap: _currentQuestionIndex > 0
                          ? _previousQuestion
                          : () {
                        Navigator.pop(context); // Go back to the previous screen
                      },// Disable if at the first question
                      child: Row(
                        children: [
                          SizedBox(
                            height: 37,
                            width: 37,
                            child: Image.asset(
                              "images/left-arrow (1).png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontFamily: "MontserratSemi",
                              color: _currentQuestionIndex > 0 ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // NEXT BUTTON
                    GestureDetector(
                      onTap: _currentQuestionIndex < _questions.length - 1 ? _nextQuestion : null, // Disable if at the last question
                      child: Row(
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              fontFamily: "MontserratSemi",
                              color: _currentQuestionIndex < _questions.length - 1 ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Transform.rotate(
                            angle: 3.1416,
                            child: SizedBox(
                              height: 37,
                              width: 37,
                              child: Image.asset(
                                "images/left-arrow (1).png",
                                fit: BoxFit.contain,
                                color: _currentQuestionIndex < _questions.length - 1 ? Colors.grey[400] : Colors.grey[600], // Grey out if disabled
                              ),
                            ),
                          ),
                        ],
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

class _Question {
  final int questionId;
  final String statement;
  final List<_Choice> choices;

  _Question({required this.questionId, required this.statement, required this.choices});

  factory _Question.fromJson(Map<String, dynamic> json) {
    return _Question(
      questionId: json['question_id'] as int,
      statement: json['statement'] as String,
      choices: (json['choices'] as List)
          .map((choice) => _Choice.fromJson(choice as Map<String, dynamic>))
          .toList(),
    );
  }
}

class _Choice {
  final int choiceId;
  final String answer;

  _Choice({required this.choiceId, required this.answer});

  factory _Choice.fromJson(Map<String, dynamic> json) {
    return _Choice(
      choiceId: json['choice_id'] as int,
      answer: json['answer'] as String,
    );
  }
}