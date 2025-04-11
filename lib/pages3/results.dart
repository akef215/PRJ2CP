import 'package:esi_quiz/pages3/stats.dart';
import 'package:esi_quiz/widgets/appbar.dart';
import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsState();
}

final List<Map<String, String>> quizData = [
  {'title': 'QUIZ 07', 'date': 'Quiz date'},
  {'title': 'SURVEY 02', 'date': 'Survey date'},
  {'title': 'QUIZ 06', 'date': 'Quiz date'},
  {'title': 'SURVEY 01', 'date': 'Survey date'},
  {'title': 'QUIZ 05', 'date': 'Quiz date'},
  {'title': 'QUIZ 04', 'date': 'Quiz date'},
];


class _ResultsState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Custom_appBar(),
      extendBodyBehindAppBar: true ,
      body: Stack(
        children: [
          // Dark Blue Background
          Container(
            height: screenHeight ,
            color: Color(0xff21334E),
          ),

          // Light blue
          Positioned.fill(
            child: ClipPath(
              clipper: DiagonalClipper(),
              child: Container(
                color: Color(0xffC8E5FF),
              ),
            ),
          ),

          // Results and Scores Container
          Positioned(
            top: screenHeight * 0.11,
            left: screenWidth * 0.2,
            right: screenWidth * 0.2,
            child: Container(
              height: screenHeight * 0.22,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Color(0xff21334E),
                  width: 10,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("images/illustration2_1.png", height: 100), // Add your image
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    "Results and Scores",
                    style: TextStyle(
                      fontFamily: "RammettoOne",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff21334E),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Quiz Boxes
          Positioned( /*------------SCROLLABLE SECTION------------*/
            top: screenHeight * 0.35,
            child: SizedBox(
              height: screenHeight * 0.52,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: quizData.map((quiz) {
                    return quizBox(
                      context: context,
                      title: quiz['title'] ?? 'Unknown Quiz',
                      date: quiz['date'] ?? 'Unknown Date',
                      onCheckStats: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Statistics()),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // Back Arrow
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                child: GestureDetector(
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper to Create Diagonal Effect
class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0 , 0);
    path.lineTo(size.width , 0);
    path.lineTo(0, size.height * 0.3); // Diagonal line down
    path.lineTo(0, size.height); // Go straight down
    path.lineTo(0, size.height); // Go left
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget quizBox({required BuildContext context,required String title, required String date, required VoidCallback onCheckStats}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Container(
    width: screenWidth * 0.8,
    height: screenHeight * 0.12,
    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 8),
    padding: EdgeInsets.only(top: 20, bottom: 12, right: 15, left: 40),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontFamily: "RammettoOne",
                    color: Color(0xff21334E),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 5),
              Text(
                date,
                style: TextStyle(
                    fontFamily: "MontserratSemi",
                    color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        SizedBox(
          height: screenHeight * 0.07,
          width: screenWidth * 0.22,
          child: ElevatedButton(
            onPressed: onCheckStats, // Function when button is pressed
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffC8E5FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Check Stats", style: TextStyle(fontSize: 12 ,color: Color(0xff21334E),)),
          ),
        ),
      ],
    ),
  );
}
