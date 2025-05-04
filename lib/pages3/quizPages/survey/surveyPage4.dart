import 'package:esi_quiz/pages3/quizPages/survey/submitSurvey.dart';
import 'package:flutter/material.dart';

import '../../../widgets/appbar.dart';

class SurveyPage4 extends StatefulWidget {
  const SurveyPage4({super.key});

  @override
  State<SurveyPage4> createState() => _SurveyPage4State();
}

class _SurveyPage4State extends State<SurveyPage4> {
  // Dynamic data (will be fetched from the API)
  String quizTimeText = "Loading..."; // Placeholder for "Quiz Time"
  String questionMarkText = "Loading..."; // Placeholder for "Question Mark"
  String question = "Loading question...";
  List<String> answers = ["True", "False"];

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
  //         answerImages = List<String>.from(data["answers"].map((ans) => ans["image"]));
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
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: Custom_appBar().buildAppBar(context, "Quiz", true),

      /*-------------------------------MAIN---------------------------*/
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,

        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.grey.withOpacity(0.2),
                  BlendMode.srcATop,
                ),
                child: Opacity(
                  opacity: 0.9, // Still keep the image at 90% opacity
                  child: Image.asset(
                    "images/background.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Positioned(
              top: screenHeight * 0.1,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*--------------------QUIZ TIME BOX-----------------*/
                  Container(
                    height: screenHeight * 0.08,
                    width: screenWidth * 0.58,
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 10,
                      left: 80,
                      right: 80,
                    ),
                    padding: EdgeInsets.only(
                      right: 60,
                      left: 65,
                      top: 15,
                      bottom: 0,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff21334E),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Color(0xff8AB3D7), width: 5),
                    ),
                    child: Text(
                      quizTimeText,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "MontserratSemi",
                        fontSize: 15,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  /*-------------------QUESTION BOX--------------------*/
                  Container(
                    height: screenHeight * 0.29,
                    width: screenWidth * 0.7,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xff21334E),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Question 4",
                          style: TextStyle(
                            fontFamily: "RammettoOne",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 15),
                        Text(
                          question,
                          style: TextStyle(
                            color: Colors.white,
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
                    height: screenHeight * 0.08,
                    width: screenWidth * 0.58,
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 10,
                      left: 80,
                      right: 80,
                    ),
                    padding: EdgeInsets.only(
                      right: 60,
                      left: 65,
                      top: 15,
                      bottom: 0,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff21334E),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Color(0xff8AB3D7), width: 5),
                    ),
                    child: Text(
                      quizTimeText,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "MontserratSemi",
                        fontSize: 15,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  /*--------------------ANSWERS BOX(TRUE/FALSE)-------------------*/
                  Theme(
                    data: Theme.of(context).copyWith(
                      checkboxTheme: CheckboxThemeData(
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1.5,
                        ), // White borders
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            7,
                          ), // Rounded corners
                        ),
                        checkColor: MaterialStateProperty.all(
                          const Color(0xff21334E),
                        ), // Inner check color
                        fillColor: MaterialStateProperty.resolveWith<Color>((
                          states,
                        ) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors
                                .white; // Background color when checked
                          }
                          return Colors
                              .transparent; // Transparent when unchecked
                        }),
                      ),
                    ),
                    child: Container(
                      width: screenWidth * 0.5,
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xff21334E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            answers
                                .map(
                                  (answer) => Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Transform.scale(
                                          scale: 1.5, // Resizing the checkboxes
                                          child: Checkbox(
                                            value: selectedAnswers.contains(
                                              answer,
                                            ),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                selectedAnswers.clear();
                                                if (value == true)
                                                  selectedAnswers.add(answer);
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ), // Spacing between checkbox and text
                                        Text(
                                          answer,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "RammettoOne",
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 60),
                  Padding(
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
                                  color: Color(0xff21334E),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // NEXT BUTTON
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubmitSurvey(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'Next',
                                style: TextStyle(
                                  fontFamily: "MontserratSemi",
                                  color: Color(0xff21334E),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
