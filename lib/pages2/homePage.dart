import 'package:esi_quiz/pages3/quizPages/quizChoice.dart';
import 'package:esi_quiz/widgets/appbar.dart';
import 'package:flutter/material.dart';
import '../pages3/feedbacks.dart';
import '../pages3/quizzes.dart';
import '../pages3/results.dart';
import '../pages3/stats.dart';
import '../widgets/project_card.dart';
import 'agenda.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffFFFDFD),

      /*-----------------APPBAR------------------*/
      appBar: Custom_appBar(),

      /*----------------------MAIN-----------------------*/
      body: Padding(
        padding:  EdgeInsets.only(top: screenHeight * 0.04, left: screenWidth * 0.05, right: screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: const Text(
                "Hi student !",
                style: TextStyle(
                  fontFamily: "RammettoOne",
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff21334E),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.018),

            /*---------------SEARCH BAR---------------*/
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      width: screenWidth * 0.07,
                      height: screenHeight * 0.035,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Circle around search icon
                        border: Border.all(color: Color(0xff87bcfe), width: 2),
                      ),
                      child: Icon(
                          Icons.search, color: Color(0xff87bcfe), size: 22),
                    ),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            /*-----------------WELCOME CARD----------------*/
            Container(

              padding: const EdgeInsets.only(
                  top: 8, bottom: 8, left: 30, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xff21334E), width: 5),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),

              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome!",
                          style: TextStyle(
                            fontFamily: "RammettoOne",
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff21334E),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "Let’s get started on something amazing",
                          style: TextStyle(
                            fontFamily: "MontserratSemi",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2E63B3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        "images/girl.png", fit: BoxFit.contain,)
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.03,),

            /*--------------ONGOING PROJECTS-----------------*/
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                "What do you need",
                style: TextStyle(
                  fontFamily: "Moul",
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff0F3D64),
                ),
              ),
            ),
             SizedBox(height: screenHeight * 0.025),

            /*-----------------PROJECTS GRID------------------*/
            Expanded(
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 25,
                childAspectRatio: 1.1,
                children: [
                  ProjectCard(
                    imagePath: "images/illustration1.png",
                    text: "Quizzes and surveys",
                    defaultTextColor: Color(0xff21334E),
                    defaultColor: Color(0xffdff0ff),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuizChoice()),
                      );
                    },
                  ),
                  ProjectCard(
                    imagePath: "images/illustration2.png",
                    text: "Results and scores",
                    defaultTextColor: Color(0xff21334E),
                    defaultColor: Color(0xffdff0ff),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResultsPage()),
                      );
                    },
                  ),
                  ProjectCard(
                    imagePath: "images/illustration3.png",
                    text: "Statistics",
                    defaultTextColor: Color(0xff21334E),
                    defaultColor: Color(0xffdff0ff),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Statistics()),
                      );
                    },
                  ),
                  ProjectCard(
                    imagePath: "images/illustration4.png",
                    text: "Feedback",
                    defaultTextColor: Color(0xff21334E),
                    defaultColor: Color(0xffdff0ff),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedbackPage()),
                      );
                    },
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
