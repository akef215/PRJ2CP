import 'package:flutter/material.dart';

import '../../../widgets/appbar.dart';
import '../../../pages2/homePage.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:esi_quiz/pages3/quizPages/Quiz1WP/quizQuestion.dart';

import 'package:esi_quiz/pages3/quizPages/Quiz1WP/QWP_page1.dart';
import 'package:esi_quiz/widgets/appbar.dart';
import 'package:flutter/material.dart';
import '../../../pages1/logMobile.dart';
import '../Quiz1/QuestionInfo.dart';

import 'dart:convert';
import 'dart:async';

class SubmitSurvey extends StatefulWidget {
  //const SubmitSurvey({super.key});
  final int totalQuestions;
  final List<int> answeredQuestions;
  final List<Questioninfo> questions;
  final List<List<int>> userAnswers;
  final String quizId;
  const SubmitSurvey({
    required this.totalQuestions,
    required this.answeredQuestions,
    super.key,
    required this.questions,
    required this.userAnswers,
    required this.quizId,
  });

  @override
  State<SubmitSurvey> createState() => _SubmitSuvey();
}

class _SubmitSuvey extends State<SubmitSurvey> {
  int totalQuestions = 0;
  List<int> answeredQuestions = []; // To simulate the question indexes
  void initState() {
    super.initState();
    totalQuestions = widget.totalQuestions;
    answeredQuestions = widget.answeredQuestions;
  }

  //_SubmitSuvey(this.totalQuestions, this.answeredQuestions);

  bool isAnswered(int index) {
    return answeredQuestions.contains(index);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Custom_appBar().buildAppBar(context, "Submit", true),

      /*----------------------------MAIN--------------------------*/
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              vertical: screenHeight * 0.07,
            ),
            child: Center(
              child: Wrap(
                /*-----------------ANSWERS LIST------------------*/
                spacing: 20,
                runSpacing: 25,
                children: List.generate(
                  totalQuestions,
                  (index) => Container(
                    width: screenWidth * 0.13,
                    height: screenHeight * 0.075,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isAnswered(index) ? Color(0xff0F3D64) : Colors.white,
                      border: Border.all(color: Color(0xff0F3D64), width: 3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontFamily: "RammettoOne",
                        color:
                            isAnswered(index)
                                ? Colors.white
                                : Color(0xff0F3D64),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Are you sure about your answers ?",
              style: TextStyle(
                fontFamily: "MontserratSemi",
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xff4C7090),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 30),

          /*------------------SUBMIT BUTTON-------------------*/
          ElevatedButton(
            onPressed: () {
              handleSubmit(widget.questions, widget.userAnswers);
            },

            style: ElevatedButton.styleFrom(
              elevation: 0.2,
              backgroundColor: Color(0xffDCEEFE),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              minimumSize: Size(200, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Color(0xff0F3D64), width: 5),
              ),
            ),
            child: Text(
              "Submit",
              style: TextStyle(
                color: Color(0xff21334E),
                fontFamily: "RammettoOne",
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Spacer(),
          /*-----------------BACK ARROW----------------------*/
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 65, left: 20, bottom: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Go back to previous page
                },
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

                    SizedBox(width: 7),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: "MontserratSemi",
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 /* double calculateScore(
    List<Questioninfo> questions,
    List<List<int>> userAnswers,
  ) {
    double score = 0;

    for (int i = 0; i < questions.length; i++) {
      final userChoices = userAnswers[i];

      // Check if user selected the correct answers, avoiding double-counting
      for (int choiceId in userChoices) {
        // Find the corresponding choice to get the points
        final choice = questions[i].choices.firstWhere(
          (choice) => choice.choicesId == choiceId,
        );
        score = score + choice.points;
        print("///////////////////////////////////////// $score");
      }
    }
    return score;
  }*/

  void handleSubmit(
    List<Questioninfo> questions,
    List<List<int>> userAnswers,
  ) async {
   // double score = calculateScore(questions, userAnswers);

    //print("Final Score: $score");

    // Optionally send data to backend here

    // Show success + score
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quiz submitted successfully!'),
        backgroundColor: Colors.lightBlueAccent[100],
        duration: Duration(seconds: 3),
      ),
    );

    // Wait then go home
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ), // Replace with your home widget
      (route) => false,
    );

    /// sending info back to the backend
    sendResponseToBackend(questions, userAnswers);
  }


   Future<Map<String, dynamic>> fetchStudentInfo() async {
    // print("something again?");
    final response = await http.get(Uri.parse(path + '/students/me/profile'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(
        'Response Body--------------------------------------: ${response.body}',
      );

      return {
        'StudentId': data['id'],
        'name': data['name'], // Keep this as it is (already an integer)
        'email': data['email'],
        'level': data['level'],
        'goupe_id': data['groupe_id'],
      };
    } else {
      print("error respose ");
      throw Exception('Failed to load quiz');
    }
  }

  Future<void> sendResponseToBackend(
    List<Questioninfo> questions,
    List<List<int>> userAnswers,
  ) async {
     final data = await fetchStudentInfo();
    String studentId = data['StudentId'];
    for (int i = 0; i < widget.totalQuestions; i++) {
      final userChoices = userAnswers[i];
      for (int choiceId in userChoices) {
        // Find the corresponding choice to get the points
        final choice = questions[i].choices.firstWhere(
          (choice) => choice.choicesId == choiceId,
        );

        //int QuizId =2; ///////////////////////////////////////////////////////////////////////////////in this case only
        final url = Uri.parse(
          path +
              '/students/answer_quiz/' +
              widget.quizId +
              '/question/' +
              questions[i].questionId.toString() +
              '?choice_id=' +
              choiceId.toString(),
        );

        // For a POST request with JSON data
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $bearerToken',
          },
          body: jsonEncode({
            'id': 1,
            'quizz_id': widget.quizId,
            'choice_id': choiceId,
            'question_id': questions[i].questionId,
            'student_id': studentId, //change into a variable when lina answers
          }),
        );

        if (response.statusCode == 200) {
          print('Response sent successfully');
        } else {
          print('Failed to send response: ${response.statusCode}');
        }
      }
    }
  }
}
