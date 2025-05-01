/*------------------PAGES OF THE QUIZ------------------*/

import 'dart:convert';

//import 'package:esi_quiz/pages3/quizPages/Quiz1WP/Questioninfo.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../../pages2/homePage.dart';
import '../../../widgets/appbar.dart';
import '../Quiz1/QuestionInfo.dart';

import '../../../pages1/logMobile.dart';

//correct one is this

// Future<Map<String, dynamic>> fetchQuizData() async {
//   await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
//
//   final fakeJson = {
//     "quizId": 123,
//     "timeLimit": 5,
//     "totalQuestions": 2,
//     "questions": [
//       {
//         "statement": "What is Flutter?",
//         "choices": [
//           {
//             "choiceId": 1,
//             "answer": "A mobile development SDK",
//             "points": 1
//           },
//           {
//             "choiceId": 2,
//             "answer": "A backend framework",
//             "points": 0
//           },
//         ]
//       },
//       {
//         "statement": "Who developed Dart?",
//         "choices": [
//           {
//             "choiceId": 3,
//             "answer": "Google",
//             "points": 1
//           },
//           {
//             "choiceId": 6,
//             "answer": "Facebook",
//             "points": 0
//           },
//           {
//             "choiceId": 7,
//             "answer": "A backend framework",
//             "points": 0
//           },
//           {
//             "choiceId": 9,
//             "answer": "A backend framework",
//             "points": 0
//           }
//         ]
//       }
//     ]
//   };
//
//   return {
//     'quizId': fakeJson['quizId'],
//     'timeLimit': fakeJson['timeLimit'],
//     'totalQuestions': fakeJson['totalQuestions'],
//     'questions': (fakeJson['questions'] as List)
//         .map((q) => Questioninfo.fromJson(q))
//         .toList(),
//   };
// }

class QuizWPPage1 extends StatefulWidget {
  final String quizIdString;
  const QuizWPPage1({super.key, required this.quizIdString});

  @override
  State<QuizWPPage1> createState() => _QuizWPPage1State();
}

class _QuizWPPage1State extends State<QuizWPPage1> {
  late List<Questioninfo> questions;
  late int timeLimit;
  late int quizId;

  String questionMarkText = "Loading..."; // Placeholder for points info
  List<ChoicesNew> choices =
      []; // ← Was List<String> answers — now it's a list of Choice objects

  int totalQuestions = 1;
  int currentPage = 0;

  // UserAnswers will store a list of selected choiceIds per question
  List<List<int>> userAnswers = [];

  late Timer _timer;
  int _remainingTime = 0;

  bool isLoading = true;
  bool error = false;

  Future<Map<String, dynamic>> fetchQuizData() async {
    // print("something again?");
    final response = await http.get(
      Uri.parse(
        path + '/quizzes/quizzes/' + widget.quizIdString + '/details_more',
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(
        'Response Body--------------------------------------: ${response.body}',
      );

      return {
        'quizId': data['quiz_id'],
        'timeLimitMinutes':
            data['time_limit_minutes'], // Keep this as it is (already an integer)
        'totalQuestions': data['total_questions'],
        'questions':
            (data['questions'] as List)
                .map((q) => Questioninfo.fromJson(q))
                .toList(),
      };
    } else {
      print("error respose ");
      error = true;
      throw Exception('Failed to load quiz');
    }
  }

  @override
  void initState() {
    super.initState();
    loadQuizData();
  }

  void loadQuizData() async {
    try {
      final data = await fetchQuizData();

      setState(() {
        print("Inside setState");
        quizId = data['quizId'];
        totalQuestions = data['totalQuestions'];
        if (totalQuestions == 0) {
          error = true;
        }

        // No need to parse again — already Questioninfo objects
        questions = List<Questioninfo>.from(data['questions']);
        if (questions.isEmpty) {
          error = true;
        }
        userAnswers = List.generate(totalQuestions, (index) => []);
        choices = questions[currentPage].choices;
        questionMarkText =
            "${choices.fold(0.0, (sum, c) => sum + c.points)} p";
        timeLimit = questions[currentPage].timeLimitSeconds;

        _remainingTime = timeLimit;
        isLoading = false;
      });

      startTimer();
    } catch (e) {
      print('Error loading quiz data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        timer.cancel();
        nextPage();
      }
    });
  }

  void nextPage() async {
    if (currentPage < totalQuestions - 1) {
      setState(() {
        currentPage++;
        choices = questions[currentPage].choices;
        questionMarkText =
            "${questions[currentPage].choices.fold<double>(0, (sum, c) => sum + c.points)} p";
        _remainingTime = timeLimit;
      });

      _timer.cancel();
      startTimer();
    } else {
      print('Quiz complete: $userAnswers');
      // You could call a submitQuiz() method here
    }
  }

  void toggleAnswer(int choiceId) {
    setState(() {
      if (userAnswers[currentPage].contains(choiceId)) {
        userAnswers[currentPage].remove(choiceId);
      } else {
        userAnswers[currentPage].add(choiceId);
      }
    });
  }

  // Check if the user selected the correct answer for the current question
  bool isAnswerCorrect(int choiceId) {
    // Check if the selected choice_id(s) match the correct answer(s) for the current question
    return questions[currentPage].choices.any(
      (choice) => choice.choicesId == choiceId && choice.points > 0,
    );
  }

  int calculateScore() {
    int score = 0;

    for (int i = 0; i < questions.length; i++) {
      final correctChoices =
          questions[i].choices
              .where(
                (choice) => choice.points > 0,
              ) // Get the correct choices based on points
              .map((choice) => choice.choicesId)
              .toList();

      final userChoices = userAnswers[i];

      // Check if user selected the correct answers, avoiding double-counting
      for (int choiceId in userChoices) {
        if (correctChoices.contains(choiceId)) {
          // Find the corresponding choice to get the points
          final choice = questions[i].choices.firstWhere(
            (choice) => choice.choicesId == choiceId,
          );
          score +=
              choice.points
                  .toInt(); // Add points for the correct answer (cast to int if needed)
        }
      }
    }
    return score;
  }

  void handleSubmit() async {
    int score = calculateScore();

    print("User answers: $userAnswers");
    print("Final Score: $score");

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
    sendResponseToBackend();
  }

  Future<Map<String, dynamic>> fetchStudentInfo() async {
    // print("something again?");
    final response = await http.get(
      Uri.parse(path + '/students/me/profile'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
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
      print("error respose Fetching Student info ${response.statusCode}");
      throw Exception('Failed to load quiz');
    }
  }

  Future<void> sendResponseToBackend() async {
    final data = await fetchStudentInfo();
    String studentId = data['StudentId'];
    for (int i = 0; i < totalQuestions; i++) {
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
              widget.quizIdString +
              '/question/' +
              questions[i].questionId.toString() +
              '?choice_id=' +
              choiceId.toString(),
        );
        //final urlInfo = Uri.parse(path +'/students/me/profile');
        // final responseInfo =await http.get(

        //);

        // For a POST request with JSON data
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $bearerToken',
          },
          body: jsonEncode({
            'id': 1,
            'quizz_id': quizId,
            'choice_id': choiceId,
            'question_id': questions[i].questionId,
            'student_id': studentId,
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

  Widget buildAnswerOption(ChoicesNew choice) {
    /*--------------WIDGET FOR ANSWER BOXES---------------*/
    double screenHeight = MediaQuery.of(context).size.height;

    //bool isSelected = userAnswers[currentPage].contains(answer);

    bool isSelected = userAnswers[currentPage].contains(choice.choicesId);
    return GestureDetector(
      onTap: () => toggleAnswer(choice.choicesId),
      child: Container(
        //height: screenHeight * 0.075,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffc8e5ff) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Color(0xff1F4E79) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Color(0xff0f3d64) : Color(0xff0f3d64),
              size: 25,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                choice.answer,
                style: TextStyle(
                  fontFamily: "MontserratThin",
                  color: Color(0xff0f3d64),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Custom_appBar().buildAppBar(context, "Quiz", false),

      /*------------------------------MAIN---------------------------------------*/
      extendBodyBehindAppBar: true,
      body:
          isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        color: Color(0xff0F3D64),
                        strokeWidth: 4,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Loading quiz...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff21334E),
                        fontFamily: "MontserratSemi",
                      ),
                    ),
                  ],
                ),
              )
              : error
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenHeight * 0.23,
                      height: screenHeight * 0.23,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200.0),
                        child: Image.asset(
                          "images/NotWrokingBlue.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Unknown Error has accorred ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff21334E),
                        fontFamily: "MontserratSemi",
                      ),
                    ),
                  ],
                ),
              )
              : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFfC8E5FF), // Light blue top
                      Color(0xFFEEF7FF), // Soft blue bottom
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.22),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center, //middle of the stack
                        children: [
                          Container(
                            /*--------------ANSWERS BOX-----------------*/
                            margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.11,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.07,
                              vertical: screenHeight * 0.07,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xff21334E),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: Offset(3, 3),
                                ),
                              ],
                            ),
                            // child: Column(
                            //   children: answers.map((answer) => buildAnswerOption(answer)).toList(),
                            //
                            // ),
                            child: Column(
                              children:
                                  choices
                                      .map(
                                        (choice) => buildAnswerOption(choice),
                                      )
                                      .toList(),
                            ),
                          ),

                          Positioned(
                            //TIME REMAINING
                            top: -65,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  /*-------------INNER CIRCLE FOR BACKGROUND----------------*/
                                  width: screenWidth * 0.2,
                                  height: screenHeight * 0.095,
                                  decoration: BoxDecoration(
                                    color: Color(
                                      0xffeef7ff,
                                    ), // Lighter inner background
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                SizedBox(
                                  /*-------------PROGRESS CIRCLE------------------*/
                                  height: screenHeight * 0.095,
                                  width: screenWidth * 0.2,
                                  child: CircularProgressIndicator(
                                    value: _remainingTime / timeLimit,
                                    strokeWidth: 8,
                                    color: Color(0xff21334e),
                                    backgroundColor: Color(0xffdaeeff),
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),

                                Text(
                                  '$_remainingTime',
                                  style: TextStyle(
                                    color: Color(0xff21334e),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      /*------------------QUESTION MARK BOX--------------------*/
                      Container(
                        height: screenHeight * 0.075,
                        width: screenWidth * 0.5,
                        margin: EdgeInsets.only(
                          bottom: 10,
                          left: 80,
                          right: 80,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 75,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffFFFDFD),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Color(0xff0F3D64),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            questionMarkText,
                            style: TextStyle(
                              color: Color(0xff21334E),
                              fontFamily: "MontserratSemi",
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),

                      // // NEXT BUTTON
                      // Expanded(
                      //   child: Align(
                      //     alignment: Alignment.bottomRight,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(12.0),
                      //       child: GestureDetector(
                      //         onTap: () {
                      //           nextPage();
                      //         },
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.end,
                      //           children: [
                      //             Text(
                      //               'Next',
                      //               style: TextStyle(
                      //                 fontFamily: "MontserratSemi",
                      //                 color: Colors.grey[400],
                      //                 fontSize: 18,
                      //               ),
                      //             ),
                      //             SizedBox(width: 7),
                      //             Transform.rotate(
                      //               angle: 3.1416, // Rotate 180 degrees
                      //               child: SizedBox(
                      //                 height: 37,
                      //                 width: 37,
                      //                 child: Image.asset("images/left-arrow (1).png", fit: BoxFit.contain),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      if (currentPage == totalQuestions - 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ElevatedButton(
                            onPressed: handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff0F3D64),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Submit Quiz",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "MontserratSemi",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
    );
  }
}
