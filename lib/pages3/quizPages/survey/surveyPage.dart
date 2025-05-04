import 'package:esi_quiz/pages3/quizPages/survey/surveyPage2.dart';
import 'package:esi_quiz/widgets/appbar.dart';
import 'package:flutter/material.dart';

import '../../../pages2/agenda.dart';
import '../../../pages2/profile.dart';



class SurveyPage1 extends StatefulWidget {
  const SurveyPage1({super.key});

  @override
  State<SurveyPage1> createState() => _SurveyPage1State();
}

class _SurveyPage1State extends State<SurveyPage1> {

  // Dynamic data (will be fetched from the API)
  String quizTimeText = "Loading...";  // Placeholder for "Quiz Time"
  String questionMarkText = "Loading...";  // Placeholder for "Question Mark"
  String question = "Loading question...";
  List<String> answers = ["A propositional variable is a formula", "Answer2", "Answer3", "Answer4", "Answer5", "Answer6"]; // TODO : ANSWERS ARE FETCHED FROM WEBSITE

  // Store the selected answers by user
  Set<String> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    // TODO: Fetch quiz data from API here when the backend is ready
    //  fetchQuizData();
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

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffFFFDFD),

      /*-----------------APPBAR------------------*/
      appBar:Custom_appBar().buildAppBar(context, "Quiz", true),

      /*------------------------------MAIN---------------------------------------*/

      body: Column(
        children: [
          /*--------------------QUIZ TIME BOX-----------------*/
          Container(
            height: screenHeight * 0.07,
            width: screenWidth * 0.58,
            margin: EdgeInsets.only(top: 20, bottom : 10, left: 80, right: 80),
            padding: EdgeInsets.symmetric(horizontal: 65, vertical: 15),
            decoration: BoxDecoration(
              color: Color(0xffFFFDFD),
              borderRadius: BorderRadius.circular(40) ,
              border: Border.all(color: Color(0xff0F3D64), width : 1),
            ),
            child : Text(
              quizTimeText ,
              style: TextStyle(
                color: Color(0xff21334E) ,
                fontFamily: "MontserratSemi" ,
                fontSize: 15 ,
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
              borderRadius: BorderRadius.circular(30) ,
              border: Border.all(color: Color(0xff0F3D64), width : 10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text(
                  "Question 1",
                  style: TextStyle(
                    fontFamily: "RammettoOne",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff21334E),
                  ),
                ),

                SizedBox(height: 15,),
                Text(
                  question,
                  style: TextStyle(
                    fontFamily: "MontserratSemi",
                    fontSize: 13 ,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 15,),

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

          SizedBox(height: 2,),

          /*--------------------ANSWERS BOX-------------------*/
          Theme(
            data: Theme.of(context).copyWith(
              checkboxTheme: CheckboxThemeData(
                side: BorderSide(color: Colors.white, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                checkColor: MaterialStateProperty.all(Color(0xff21334E)),
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
                child: ListView.builder(
                  itemCount: answers.length,
                  itemBuilder: (context, index) {
                    String answer = answers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Transform.scale( // Resize the checkbox
                            scale: 1.3,
                            child: Checkbox(
                              value: selectedAnswers.contains(answer),
                              onChanged: (bool? value) {
                                setState(() {
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
                ),
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
                padding: const EdgeInsets.only(left: 20, bottom: 15, right:20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes them to left & right
                  children: [
                    // BACK BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Go back to previous page
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            height: 37,
                            width: 37,
                            child: Image.asset("images/left-arrow (1).png", fit: BoxFit.contain),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyPage2())) ;
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
                              child: Image.asset("images/left-arrow (1).png", fit: BoxFit.contain),
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

