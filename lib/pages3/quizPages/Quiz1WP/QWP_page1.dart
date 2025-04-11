import 'package:flutter/material.dart';
import 'dart:async';
import '../../../widgets/appbar.dart';

// Future<Map<String, dynamic>> fetchQuizData() async {
//   // Simulate fetching data from backend
//   await Future.delayed(Duration(seconds: 1));
//   return {
//     'timeLimit': 30,
//     'answers': ['Strongly satisfied', 'Satisfied', 'Neutral', 'Not satisfied'],
//     'totalQuestions': 5
//   };
// }

Future<Map<String, dynamic>> fetchSimulatedPageData(int page) async {
  await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
  return {
    'timeLimit': 30,
    'answers': [
      'Answer ${page * 4 + 1}',
      'Answer ${page * 4 + 2}',
      'Answer ${page * 4 + 3}',
      'Answer ${page * 4 + 4}'
    ],
    'totalQuestions': 5
  };
}

class QuizWPPage1 extends StatefulWidget {
  const QuizWPPage1({super.key});



  @override
  State<QuizWPPage1> createState() => _QuizWPPage1State();

}

class _QuizWPPage1State extends State<QuizWPPage1> {

  int timeLimit = 30;
  String questionMarkText = "Loading...";  // Placeholder for "Question Mark"
  List<String> answers = [];
  int totalQuestions = 1;
  int currentPage = 0;
  List<List<String>> userAnswers = [];

  late Timer _timer;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    loadQuizData();
  }

  void loadQuizData() async {
    var data = await fetchSimulatedPageData(currentPage);
    setState(() {
      timeLimit = data['timeLimit'];
      answers = List<String>.from(data['answers']);
      totalQuestions = data['totalQuestions'];
      userAnswers = List.generate(totalQuestions, (index) => []);
      _remainingTime = timeLimit;
      startTimer();
    });
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

  // void nextPage() {
  //   if (currentPage < totalQuestions - 1) {
  //     setState(() => currentPage++);
  //     _remainingTime = timeLimit;
  //     startTimer();
  //   } else {
  //     // Submit or end survey
  //     print('Survey complete: $userAnswers');
  //   }
  // }

  void nextPage() async {
    if (currentPage < totalQuestions - 1) {
      setState(() => currentPage++);

      // Fetch new answers for the new page
      var newPageData = await fetchSimulatedPageData(currentPage);

      setState(() {
        answers = List<String>.from(newPageData['answers']);
        _remainingTime = timeLimit; // Reset the timer

      });
      _timer.cancel();
      startTimer();
    } else {
      print('Survey complete: $userAnswers');
    }
  }


  void toggleAnswer(String answer) {
    setState(() {
      if (userAnswers[currentPage].contains(answer)) {
        userAnswers[currentPage].remove(answer);
      } else {
        userAnswers[currentPage].add(answer);
      }
    });
  }

  Widget buildAnswerOption(String answer) {/*--------------WIDGET FOR ANSWER BOXES---------------*/
    double screenHeight = MediaQuery.of(context).size.height;

    bool isSelected = userAnswers[currentPage].contains(answer);

    return GestureDetector(
      onTap: () => toggleAnswer(answer),
      child: Container(
        height: screenHeight * 0.075,
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
              isSelected
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: isSelected ? Color(0xff0f3d64) : Color(0xff0f3d64),
              size: 25,
            ),
            SizedBox(width: 10),
            Text(
              answer,
              style: TextStyle(
                fontFamily: "MontserratThin",
                color: Color(0xff0f3d64),
                fontSize: 16,
                fontWeight: FontWeight.w900,
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
      appBar: Custom_appBar(),

      /*------------------------------MAIN---------------------------------------*/
      extendBodyBehindAppBar: true,
      body: Container(
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
              SizedBox(height: screenHeight * 0.22,),
              Stack(
                clipBehavior: Clip.none ,
                alignment: Alignment.center, //middle of the stack
                children: [
                  Container(/*--------------ANSWERS BOX-----------------*/
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.11),
                    padding: EdgeInsets.symmetric(horizontal :screenWidth * 0.07, vertical : screenHeight * 0.07),
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
                    child: Column(
                      children: answers.map((answer) => buildAnswerOption(answer)).toList(),
                      // children: answers.map((answer) {
                      //   return CheckboxListTile(
                      //     value: userAnswers[currentPage].contains(answer),
                      //     onChanged: (bool? value) => toggleAnswer(answer),
                      //     title: Text(answer, style: TextStyle(color: Colors.white)),
                      //     activeColor: Colors.white,
                      //     checkColor: Color(0xff21334E),
                      //   );
                      // }).toList(),
                    ),
                  ),

                  Positioned( //TIME REMAINING
                    top: -65,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container( /*-------------INNER CIRCLE FOR BACKGROUND----------------*/
                          width: screenWidth * 0.2,
                          height: screenHeight * 0.095,
                          decoration: BoxDecoration(
                            color: Color(0xffeef7ff), // Lighter inner background
                            shape: BoxShape.circle,
                          ),
                        ),

                        SizedBox( /*-------------PROGRESS CIRCLE------------------*/
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

                        Text('$_remainingTime',
                            style: TextStyle(color: Color(0xff21334e),fontSize: 25, fontWeight: FontWeight.bold, fontFamily: "Montserrat")),

                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.05,),

              /*------------------QUESTION MARK BOX--------------------*/
              Container(
                height: screenHeight * 0.07,
                width: screenWidth * 0.58,
                margin: EdgeInsets.only(bottom : 10, left: 80, right: 80),
                padding: EdgeInsets.symmetric(horizontal: 65, vertical: 15),
                decoration: BoxDecoration(
                  color: Color(0xffFFFDFD),
                  borderRadius: BorderRadius.circular(40) ,
                  border: Border.all(color: Color(0xff0F3D64), width : 1),
                ),
                child : Text(
                  questionMarkText ,
                  style: TextStyle(
                    color: Color(0xff21334E) ,
                    fontFamily: "MontserratSemi" ,
                    fontSize: 15 ,
                  ),
                ),
              ),

              // NEXT BUTTON
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () {
                        nextPage();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                              child: Image.asset("images/left-arrow (1).png", fit: BoxFit.contain),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ) ,
      ),
    );
  }
}


//
// @override
// void dispose() {
//   _timer.cancel();
//   super.dispose();
// }
// }
