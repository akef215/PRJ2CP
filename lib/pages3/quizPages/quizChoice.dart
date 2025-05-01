import 'package:esi_quiz/pages3/quizPages/Quiz1WP/QType1_presentation.dart';
import 'package:esi_quiz/pages3/quizPages/survey/survey.dart';
import 'package:esi_quiz/pages3/quizPages/surveryWP/survey_presentation.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../widgets/clickable_card.dart';
import 'Quiz1/QType1.dart';
import 'Quiz2/QType2.dart';
import '../../widgets/appbar.dart';
import './QuizzesStructure.dart';
import '../quizzes.dart';

//availible Quizzes page
//decribed as part 1 in my To do list

Future<Map<String, dynamic>> fetchQuizzes() async {
  final response = await http.get(Uri.parse(path + '/quizzes/available'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print(
      'Response Body--------------------------------------: ${response.body}',
    );

    if (data is List && data.isEmpty) {
      // If the list is empty, return an empty list of quizzes
      return {'Quizzes': <Quizzesstructure>[]};
    }

    return {
      'Quizzes':
          (data as List).map((q) => Quizzesstructure.fromJson(q)).toList(),
    };
  } else {
    print("Error response");
    throw Exception('Failed to load quiz');
  }
}

Future<Map<String, dynamic>> fetchSurveys() async {
  print("something again?");
  final response = await http.get(Uri.parse(path + '/quizzes/surveys'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print(
      'Response Body--------------------------------------: ${response.body}',
    );

    if (data is List && data.isEmpty) {
      // If the list is empty, return an empty list of quizzes
      return {'Surveys': <Quizzesstructure>[]};
    }

    return {
      'Surveys':
          (data as List).map((q) => Quizzesstructure.fromJson(q)).toList(),
    };
  } else {
    print("Error response");
    throw Exception('Failed to load quiz');
  }
}

class QuizChoice extends StatefulWidget {
  const QuizChoice({super.key});

  @override
  State<QuizChoice> createState() => _QuizChoiceState();
}

class _QuizChoiceState extends State<QuizChoice> {
  bool isLoading = true;
  int totalQuizzes = 0;
  int totalSurveys = 0;

  int totalCard = 0;
  List<Quizzesstructure> quizzes = [];
  List<Quizzesstructure> surveys = [];

  @override
  void initState() {
    super.initState();
    loadPageData();
  }

  void loadPageData() async {
    try {
      final quizzesData = await fetchQuizzes();
      final surveysData = await fetchSurveys();

      setState(() {
        quizzes = quizzesData['Quizzes'];
        surveys = surveysData['Surveys'];

        totalQuizzes = quizzes.length;
        totalSurveys = surveys.length;
        totalCard = totalQuizzes + totalSurveys;
        if (quizzes.isNotEmpty) {
          for (int i = 0; i < quizzes.length; i++) {
            print("Quizz number $i");
            print("Quiz id:${quizzes[i].id}");
            print("Quiz Title:${quizzes[0].title}");
            print("Quiz date:  ${quizzes[0].date}");
            print("Quiz Type: ${quizzes[0].type_quizz}");
          }
        } else {
          print("📕 THE QUIZZES LIST IS EMPTY 📕");
        }

        if (surveys.isNotEmpty) {
          for (int i = 0; i < surveys.length; i++) {
            print("Survey number $i");
            print("Survey id:${surveys[i].id}");
            print("Survey Title:${surveys[0].title}");
            print("Survey date:  ${surveys[0].date}");
            print("Survey Type: ${surveys[0].type_quizz}");
          }
        } else {
          print("📕 THE SURVEYS LIST IS EMPTY 📕");
        }

        isLoading = false; // Set it to false AFTER loading both
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildQuizzesCards(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<Quizzesstructure> Total = quizzes + surveys;
    return GridView.count(
      // physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2, // 2 items per row
      crossAxisSpacing: 40,
      mainAxisSpacing: 30,
      childAspectRatio: 1.1,
      children: List.generate(
        Total.length,
        (index) => ClickableCard(
          mainText:
              Total[index].type_quizz == "S"
                  ? "SURVEY"
                  : Total[index].type_quizz == "2"
                  ? "QUIZ"
                  : "QUIZ presentation",
          page: Quizzes(ques: Total[index]),
          subText: Total[index].title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff21334E),

      /*-----------------APPBAR------------------*/
      appBar: Custom_appBar().buildAppBar(context, "Available Quizzes", false),

      /*-----------------BODY------------------*/
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.6,
            child: Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                top: screenHeight * 0.08,
              ),
              child: buildQuizzesCards(context),
            ),
          ),

          SizedBox(height: screenHeight * 0.03),
          Spacer(),

          /*-----------------BACK ARROW----------------------*/
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
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
}

// Widget buildCard(BuildContext context, String mainText, String? subText, Widget page) {
//   double screenHeight = MediaQuery.of(context).size.height;
//   double screenWidth = MediaQuery.of(context).size.width;
//   return GestureDetector(
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => page),
//       );
//     },
//     child: Container(
//       decoration: BoxDecoration(
//         color: Color(0xffEEF7FF),
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black38.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 12.9,
//             offset: Offset(12, 10),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               mainText,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Color(0xff21334E),
//                 fontFamily: "RammettoOne",
//                 letterSpacing: 1.5,
//                 shadows: [
//                   Shadow(
//                     color: Colors.black26, // Shadow color
//                     offset: Offset(2, 2),
//                     blurRadius: 4,
//                   ),
//                 ],
//               ),
//             ),
//             if (subText != null) // Show subtitle only if provided
//               Text(
//                 subText,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 12,
//                   color: Color(0xff21334E),
//                   fontFamily: "MontserratSemi",
//                   shadows: [
//                     Shadow(
//                       color: Colors.black26, // Shadow color
//                       offset: Offset(1, 1),
//                       blurRadius: 2,
//                     ),
//                   ],
//               ),
//               ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

PopupMenuItem<int> _buildNotificationItem(String title, String time) {
  return PopupMenuItem(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: "MontserratSemi",
            color: Color(0xff21334E),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
        Divider(), // Adds a line between notifications
      ],
    ),
  );
}
