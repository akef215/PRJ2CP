import 'package:esi_quiz/pages3/statsPages/modules_stats.dart';
import 'package:esi_quiz/pages3/statsPages/progress_stats.dart';
import 'package:esi_quiz/pages3/statsPages/quiz_stats.dart';
import 'package:esi_quiz/pages3/statsPages/survey_stats.dart';
import 'package:esi_quiz/widgets/appbar.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}




class _StatisticsState extends State<Statistics> {

  int _currentIndex = 0; // Start with -1 for the custom stats page or 0 for "survey" as default

  final List<Widget> _pages = [
    //Center(child: Text("Survey Page", style: TextStyle(fontSize: 24))),
    SurveyStats(),
    QuizStats(),
    ModulesStats(),
    ProgressStats(),
  ];

  Widget buildTabItem(int index, String text) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _currentIndex == index ? Color(0xffB2DBFF).withOpacity(0.6) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            // boxShadow: _currentIndex == index //Some shadow
            //     ? [
            //   BoxShadow(
            //     color: Color(0xff21334E).withOpacity(0.2),
            //     blurRadius: 5,
            //     offset: Offset(0, 3),
            //   ),
            // ]
            //     : [],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: _currentIndex == index ? Color(0xff21334E) : Color(0xff21334E),
              fontFamily: "MontserratThin",
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Custom_appBar().buildAppBar(context, "Statsitics", false),

      body: Column(
        children: [
          Container(//TAB ROW
            color: Colors.white,
            padding: EdgeInsets.only(top: screenHeight * 0.08, bottom: 5), // Add padding if needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTabItem(0, 'Survey'),
                buildTabItem(1, 'Quiz'),
                buildTabItem(2, 'Modules'),
                buildTabItem(3, 'Progress'),
              ],
            ),
          ),

          Divider(//LINE DIVIDER
            color: Color(0xff21334E),
            thickness: 0.7,
            height: 1,
          ),


          SizedBox(height: 20,),
          Expanded(
            child: _currentIndex == -1
                ? Center(
              child: Stack(
                children: [
                  ClipPath(
                    clipper: DiagonalClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff0F3D64),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 5,
                      right: 10,
                      left: 45,
                      bottom: 65,
                      child: Image.asset('images/statpic.png', width: 500, height: 500)
                  ),

                  /*-----------------BACK ARROW----------------------*/
                  Positioned(
                    bottom: 15,
                    left: 5,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Go back to previous page
                      },
                      child: Row(
                        children: [
                          SizedBox(
                              height: 37,
                              width: 37 ,
                              child: Image.asset("images/left-arrow (1).png" ,fit: BoxFit.contain,)
                          ),

                          SizedBox(width: 7),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontFamily: "MontserratSemi",
                              color : Colors.grey[400] ,
                              fontSize: 18 ,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
                : _pages[_currentIndex],
          ),

        ],
      ),

    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from the top-left corner
    path.lineTo(0, 0);

    // Move across the top, but stop a bit before the top-right corner
    path.lineTo(size.width , 0);

    // Start the cut lower (e.g., 20% down from the top-right edge)
    path.lineTo(size.width, size.height * 0.16);

    // Continue the diagonal inward cut
    path.lineTo(size.width * 0.55, size.height * 0.45);

    // Extend the cut to create the triangle shape
    path.lineTo(size.width, size.height * 0.65);
    path.lineTo(size.width, size.height * 0.9);

    // Finish the bottom diagonal cut
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}





