import 'package:esi_quiz/pages3/quizPages/Quiz1WP/QWP_page1.dart';
import 'package:esi_quiz/widgets/appbar.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../../pages2/homePage.dart';
import './Qpage1Submit.dart';
import './QuestionInfo.dart';

//import 'package:esi_quiz/pages3/quizPages/Quiz1WP/Questioninfo.dart';

/////START QUIZ 1
//String path = 'http://192.168.43.147:8000';

//String quizIdString ='2'; //in this case only ( need to get it from availibale Quizzes / entery on the constructor )

class QuizPage1 extends StatefulWidget {
  final String quizIdString;
  const QuizPage1({super.key, required this.quizIdString});

  @override
  State<QuizPage1> createState() => _QuizPage1State();
}

class _QuizPage1State extends State<QuizPage1> {
  late List<Questioninfo> questions;
  late int timeLimit;
  late int quizId;

  List<ChoicesNew> choices =
      []; // ← Was List<String> answers — now it's a list of Choice objects
  int totalQuestions = 1;
  int currentPage = 0;
  List<List<int>> userAnswers = [];

  List<int> answeredQuestions = [];

  late Timer _timer;
  int _remainingTime = 0;

  bool isLoading = true;

  // Dynamic data (will be fetched from the API)
  String quizTimeText = "Loading..."; // Placeholder for "Quiz Time"
  String questionMarkText = "Loading..."; // Placeholder for "Question Mark"
  String question = "Loading question...";

  // Store the selected answers by user
  Set<String> selectedAnswers = {};

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
        print("state is being set");
        // print("${data['questions']}");
        timeLimit = data['timeLimitMinutes'];
        quizId = data['quizId'];
        totalQuestions = data['totalQuestions'];
        
        questions = List<Questioninfo>.from(data['questions']);

        userAnswers = List.generate(totalQuestions, (index) => []);
        choices = questions[currentPage].choices;

        questionMarkText =
            "${choices.fold(0.0, (sum, c) => sum + c.points)} points";
        _remainingTime = timeLimit;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading quizs data:$e');
      setState(() {
        isLoading = false;
      });
    }
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        timer.cancel();
        //nextPage();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        /////////////////////////////////////////////////////////////////QUIZ ENDED
      }
    });
  }

  void nextPage() async {
    if (currentPage < totalQuestions - 1) {
      setState(() {
        currentPage++;
        choices = questions[currentPage].choices;
        questionMarkText =
            "${questions[currentPage].choices.fold<double>(0, (sum, c) => sum + c.points)} points";
        //_remainingTime = timeLimit;
      });
    } else {
      submitPage();
      print('Quiz complete: $userAnswers');
      // send info to the back ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }
  }

  void submitPage() {
    print("User answers: $userAnswers");

    print("navigating to the sumbit page");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SubmitQuizWithPers(
              totalQuestions: totalQuestions,
              answeredQuestions: answeredQuestions,
              questions: questions,
              userAnswers: userAnswers,
              quizId: quizId.toString(),
            ),
      ),
    );
    //handleSubmit();
  }

  void goBack() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        choices = questions[currentPage].choices;
        questionMarkText =
            "${questions[currentPage].choices.fold<double>(0, (sum, c) => sum + c.points)} points";
        _remainingTime = timeLimit;
      });
    } else {
      print("No going back");
    }
  }

  void onClickNavArrow() {
    nextPage();
  }

  void toggleAnswer(int choiceId) {
    setState(() {
      if (userAnswers[currentPage].contains(choiceId)) {
        userAnswers[currentPage].remove(choiceId);
        if (answeredQuestions.contains(currentPage)) {
          answeredQuestions.remove(currentPage);
        }
      } else {
        userAnswers[currentPage].add(choiceId);
        if (!answeredQuestions.contains(currentPage)) {
          answeredQuestions.add(currentPage);
        }
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

  double calculateScore() {
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
        choice.points
            .toInt(); // Add points for the correct answer (cast to int if needed)
      }
    }
    return score;
  }

  void handleSubmit() async {
    double score = calculateScore();

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
  }

  // doesn't contain toggle answer like the original
  Widget buildAnswerOption(List<ChoicesNew> choices) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //bool isSelected = userAnswers[currentPage].contains(choice.choiceId);
    return ListView.builder(
      itemCount: choices.length,
      itemBuilder: (context, index) {
        String answer = choices[index].answer;
        print(answer);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              Transform.scale(
                // Resize the checkbox
                scale: 1.3,
                child: Checkbox(
                  value: selectedAnswers.contains(answer),
                  onChanged: (bool? value) {
                    setState(() {
                      toggleAnswer(choices[index].choicesId);
                      if (value == true) {
                        selectedAnswers.add(answer);
                      } else {
                        selectedAnswers.remove(answer);
                      }
                    });
                  },
                  activeColor: Colors.white,
                  checkColor: Color(0xff21334E),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  answer,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "MontserratSemi",
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Qpage 1 Built successfully");
    //startTimer();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffFFFDFD),

      /*-----------------APPBAR------------------*/
      appBar: Custom_appBar().buildAppBar(context, "Quiz", true),

      /*------------------------------MAIN---------------------------------------*/
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
              : Column(
                children: [
                  /*--------------------QUIZ TIME BOX-----------------*/
                  Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.58,
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 10,
                      left: 80,
                      right: 80,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 65, vertical: 15),
                    decoration: BoxDecoration(
                      color: Color(0xffFFFDFD),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Color(0xff0F3D64), width: 1),
                    ),
                    child: Center(
                      child: Text(
                        _remainingTime.toString() + ' s', //quizTimeText,
                        style: TextStyle(
                          color: Color(0xff21334E),
                          fontFamily: "MontserratSemi",
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  /*-------------------QUESTION BOX--------------------*/
                  Container(
                    height: screenHeight * 0.26,
                    width: screenWidth * 0.7,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xff0F3D64), width: 10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Question ' + (currentPage + 1).toString(),
                          style: TextStyle(
                            fontFamily: "RammettoOne",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff21334E),
                          ),
                        ),

                        SizedBox(height: 15),
                        Text(
                          questions[currentPage].statement.toString(),
                          style: TextStyle(
                            fontFamily: "MontserratSemi",
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),

                  /*------------------QUESTION MARK BOX--------------------*/
                  Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.58,
                    margin: EdgeInsets.only(bottom: 10, left: 80, right: 80),
                    padding: EdgeInsets.symmetric(horizontal: 65, vertical: 15),
                    decoration: BoxDecoration(
                      color: Color(0xffFFFDFD),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Color(0xff0F3D64), width: 1),
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

                  SizedBox(height: 2),

                  /*--------------------ANSWERS BOX-------------------*/
                  Theme(
                    data: Theme.of(context).copyWith(
                      checkboxTheme: CheckboxThemeData(
                        side: BorderSide(color: Colors.white, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        checkColor: MaterialStateProperty.all(
                          Color(0xff21334E),
                        ),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xff21334E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                        height: screenHeight * 0.3,
                        child: buildAnswerOption(choices),
                      ),
                    ),
                  ),

                  // Expanded(
                  //   child: Container(
                  //     margin:  EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  //     padding: EdgeInsets.all(5),
                  //     decoration: BoxDecoration(
                  //       color: Color(0xff21334E) ,
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: ListView.builder(
                  //       itemCount: answers.length,
                  //       itemBuilder: (context, index){
                  //       children: answers.isEmpty
                  //           ? [Text("Loading answers...", style: TextStyle(color: Colors.white))] // Placeholder before API loads
                  //           : answers.map((answer) {
                  //         return Theme(
                  //           data: Theme.of(context).copyWith(
                  //             checkboxTheme: CheckboxThemeData(
                  //               side: BorderSide(color: Colors.white, width: 2), // White border when unchecked
                  //             ),
                  //           ),
                  //           child: CheckboxListTile(
                  //             title: Text(
                  //               answer,
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontFamily: "MontserratSemi",
                  //               ),
                  //             ),
                  //             value: selectedAnswers.contains(answer),
                  //             onChanged: (bool? value) {
                  //               setState(() {
                  //                 if (value == true) {
                  //                   selectedAnswers.add(answer);
                  //                 } else {
                  //                   selectedAnswers.remove(answer);
                  //                 }
                  //               });
                  //             },
                  //             controlAffinity: ListTileControlAffinity.leading,
                  //             checkColor: Color(0xff21334E),
                  //             activeColor: Colors.white,
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(11),
                  //               side: BorderSide(color: Colors.white, width: 2),
                  //             ),
                  //           ),
                  //         );
                  //       }).toList(),
                  //       )
                  //     ),
                  //   ),
                  // ),

                  /*-----------------NAVIGATION ARROW----------------------*/
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          bottom: 15,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween, // Pushes them to left & right
                          children: [
                            // BACK BUTTON
                            GestureDetector(
                              onTap: () {
                                goBack();
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

                            // NEXT BUTTON
                            GestureDetector(
                              onTap: () {
                                onClickNavArrow();
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => Quiz2())) ;
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                      fontFamily: "MontserratSemi",
                                      color: Colors.grey[400],
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(width: 7),
                                  Transform.rotate(
                                    angle: 3.1416, // Rotate 180 degrees
                                    child: SizedBox(
                                      height: 37,
                                      width: 37,
                                      child: Image.asset(
                                        "images/left-arrow (1).png",
                                        fit: BoxFit.contain,
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
                  ),
                ],
              ),
    );
  }
}







  // Function to fetch quiz data from API
  // Future<void> fetchQuizData() async {
  //   final String apiUrl = "https://yourwebsite.com/api/quiz"; // TODO: Replace with real API URL
  //
  //   try {
  //     final response = await http.get(Uri.parse(apiUrl));
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //
  //       setState(() {
  //         quizTimeText = data["quizTime"] ?? "Quiz Time"; // Fetched quiz time text
  //         questionMarkText = data["questionMark"] ?? "Question Mark"; // Fetched question mark text
  //         question = data["question"] ?? "No question available"; // Fetched question
  //         answers = List<String>.from(data["answers"] ?? []); // Fetched answers
  //       });
  //     } else {
  //       print("Failed to load data: ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     print("Error fetching quiz data: $error");
  //   }
  // }
