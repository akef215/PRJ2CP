import 'package:flutter/material.dart';

import '../../widgets/appbar.dart';
import 'Q4.dart';

class Quiz3 extends StatefulWidget {
  const Quiz3({super.key});

  @override
  State<Quiz3> createState() => _Quiz3State();
}

class _Quiz3State extends State<Quiz3> {

  // Dynamic data (will be fetched from the API)
  String quizTimeText = "Loading...";  // Placeholder for "Quiz Time"
  String questionMarkText = "Loading...";  // Placeholder for "Question Mark"
  String question = "Loading question...";
  List<String> answerImages = [
    // "https://via.placeholder.com/150", // Placeholder for A
    "images/deskGirl.png",
    // "https://via.placeholder.com/150", // Placeholder for B
    "images/deskGirl.png",
    // "https://via.placeholder.com/150", // Placeholder for C
    "images/deskGirl.png",
    // "https://via.placeholder.com/150"  // Placeholder for D
    "images/deskGirl.png",
  ];

  // Store the selected answers by user
  int? selectedAnswer ;

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

    double gridSize = screenWidth * 0.7;
    double lineWidth = 3; // Line thickness

    return Scaffold(
      backgroundColor: Color(0xffFFFDFD),

      appBar:Custom_appBar().buildAppBar(context, "Quiz", false),

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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical : 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30) ,
              border: Border.all(color: Color(0xff0F3D64), width : 10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text(
                  "Question 3",
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
            width: gridSize ,
            height: gridSize,
            child: Stack(
              children: [
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1, // Square images
                    ),

                  itemCount: 4,
                  itemBuilder: (context, index){

                    // Adjust the position of the image based on index
                    double dx = 0, dy = 0;
                    double checkDx = 0, checkDy = 0;
                    if (index == 0) {
                      dx = -18; dy = -25; // Move top-left
                      checkDx = 30; checkDy = 40;
                    } else if (index == 1) {
                      dx = 18; dy = -25;  // Move top-right
                      checkDx = -100 ; checkDy = 40;
                    } else if (index == 2) {
                      dx = -18; dy = -5;  // Move bottom-left
                      checkDx = 30; checkDy = -78;
                    } else if (index == 3) {
                      dx = 18; dy = -5;   // Move bottom-right
                      checkDx = -100; checkDy = -78;
                    }

                    return Transform.translate(
                      offset: Offset(dx, dy), // Shift position
                      child: GestureDetector( // When the user clicks on the image the checkbox is checked
                        onTap: () {
                          setState(() {
                            selectedAnswer = index;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          clipBehavior: Clip.none,
                          children: [
                            //-------------IMAGES------------
                            Container(
                              height: 100 ,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),

                              child:ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset( // TODO : Image.netwrok
                                  answerImages[index],
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),


                            // -------------CHECKBOX-------------
                            Transform.translate(
                              offset: Offset(checkDx, checkDy),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 60, // Increase tap area
                                      height: 60,
                                      child: Transform.scale(
                                        scale: 1.6,
                                        child: Checkbox(
                                          value: selectedAnswer == index, // Replace with user logic
                                          activeColor: Color(0xff21334E), // Fill color when clicked
                                          checkColor: Colors.white, // Tick color
                                          side: BorderSide(color: Color(0xff21334E), width: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              selectedAnswer = index; // Update selected answer
                                            });
                                          },
                                        ),
                                      ),
                                    ),

                                    /*-----------------------A B C D LETTERS-------------------*/
                                    Positioned(
                                      top: (index == 0 || index == 1) ? -12 : null, // Above for first row
                                      bottom: (index == 2 || index == 3) ? -12 : null, // Below for second row
                                      child: Text(
                                        String.fromCharCode(65 + index), // 'A' for index 0, 'B' for index 1, etc.
                                        style: TextStyle(
                                          fontFamily: "MontserratSemi",
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff21334E),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                /*--------------------VERTICAL DIVIDER LINE--------------------*/
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: gridSize / 2 - lineWidth / 2,
                  child: Container(
                    width: lineWidth,
                    color: Color(0xff0F3D64),
                  ),
                ),

                /*--------------------VERTICAL DIVIDER LINE--------------------*/
                Positioned(
                  left: 0,
                  right: 0,
                  top: gridSize / 2 - lineWidth / 2,
                  child: Container(
                    height: lineWidth,
                    color: Color(0xff0F3D64),
                  ),
                ),
              ],
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Quiz4())) ;
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
