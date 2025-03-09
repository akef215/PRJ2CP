import 'package:flutter/material.dart';

import '../../pages2/profile.dart';
import 'Q2.dart';

class Quiz1 extends StatefulWidget {
  const Quiz1({super.key});

  @override
  State<Quiz1> createState() => _Quiz1State();
}

class _Quiz1State extends State<Quiz1> {

  // Dynamic data (will be fetched from the API)
  String quizTimeText = "Loading...";  // Placeholder for "Quiz Time"
  String questionMarkText = "Loading...";  // Placeholder for "Question Mark"
  String question = "Loading question...";
  List<String> answers = ["Answer1", "Answer2", "Answer3", "Answer4"]; // TODO : ANSWERS ARE FETCHED FROM WEBSITE

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /*-------------GRID-----------------*/
            Container(
              padding: EdgeInsets.only(left: 12.0),
              child: PopupMenuButton(
                icon: SizedBox(
                  width: 37,
                  height: 37,
                  child: Image.asset(
                    'images/grid (1) - Copy (1).png',
                    fit: BoxFit.contain,
                  ),
                ),

                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Color(0xffdff0ff), width: 6),
                ),

                constraints: BoxConstraints.tightFor(width: 230),

                onSelected: (value) {
                  if (value == 'profile') {
                    // Navigator.pushNamed(context, '/profile');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  } else if (value == 'modules') {
                    Navigator.pushNamed(context, '/modules');
                  } else if (value == 'agenda') {
                    Navigator.pushNamed(context, '/agenda');
                  } else if (value == 'settings') {
                    Navigator.pushNamed(context, '/settings');
                  }
                },

                itemBuilder: (context) =>
                [
                  PopupMenuItem(
                    value: 'profile',
                    height: 60,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            'images/people.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text("Profile",
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w500)
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'modules',
                    height: 60,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            'images/check.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text("Modules",
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'agenda',
                    height: 60,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            'images/time.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text("Agenda",
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    height: 60,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            'images/setting (1).png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text("Settings",
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /*----------HOME TEXT---------------*/
            const Text(
              "Home",
              style: TextStyle(
                fontFamily: "MontserratSemi",
                color: Color(0xff21334E),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            /*---------NOTIFICATIONS BELL---------*/
            //TODO: MAKE IT A CLICKABLE BUTTON
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Image.asset(
                'images/bell1.png',
                width: 37,
                height: 37,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),

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
              quizTimeText ,
              style: TextStyle(
                color: Color(0xff21334E) ,
                fontFamily: "MontserratSemi" ,
                fontSize: 15 ,
              ),
            ),
          ),

          SizedBox(height: 2,),

          /*--------------------ANSWERS BOX-------------------*/
          Container(
            margin:  EdgeInsets.symmetric(horizontal: 40, vertical: 5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color(0xff21334E) ,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: answers.isEmpty
                  ? [Text("Loading answers...", style: TextStyle(color: Colors.white))] // Placeholder before API loads
                  : answers.map((answer) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    checkboxTheme: CheckboxThemeData(
                      side: BorderSide(color: Colors.white, width: 2), // White border when unchecked
                    ),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      answer,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "MontserratSemi",
                      ),
                    ),
                    value: selectedAnswers.contains(answer), // TODO: Update with actual user selection logic
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedAnswers.add(answer);
                        } else {
                          selectedAnswers.remove(answer);
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    checkColor: Color(0xff21334E),
                    activeColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Quiz2())) ;
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
