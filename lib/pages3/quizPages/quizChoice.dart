import 'package:esi_quiz/pages3/quizPages/Quiz1WP/QType1_presentation.dart';
import 'package:esi_quiz/pages3/quizPages/survey/survey.dart';
import 'package:esi_quiz/pages3/quizPages/surveryWP/survey_presentation.dart';

import 'package:flutter/material.dart';
import '../../pages2/agenda.dart';
import '../../pages2/profile.dart';
import '../../widgets/clickable_card.dart';
import 'Quiz1/QType1.dart';
import 'Quiz2/QType2.dart';

class QuizChoice extends StatefulWidget {
  const QuizChoice({super.key});

  @override
  State<QuizChoice> createState() => _QuizChoiceState();
}

class _QuizChoiceState extends State<QuizChoice> {
  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff21334E),

      /*-----------------APPBAR------------------*/
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  } else if (value == 'modules') {
                    Navigator.pushNamed(context, '/modules');
                  } else if (value == 'agenda') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Agenda()));
                  } else if (value == 'settings') {
                    Navigator.pushNamed(context, '/settings');
                  }
                },

                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    height: 60,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30, // Bigger icon
                          height: 30,
                          child: Image.asset(
                            'images/people.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text("Profile",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
                color: Color(0xffFFFDFD),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            /*---------NOTIFICATIONS BELL---------*/
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: PopupMenuButton<int>(
                icon: SizedBox(
                  width: 37,
                  height: 37,
                  child: Image.asset(
                    'images/bell1.png',
                    fit: BoxFit.contain,
                  ),
                ),
                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Color(0xffdff0ff), width: 6),
                ),
                constraints: BoxConstraints.tightFor(width: 250),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: false, // Disable selection
                    child: SizedBox(
                      height: 200, // Limit height to make it scrollable
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            6, // Simulating 10 notifications
                                (index) => _buildNotificationItem("Notification ${index + 1}", "${(index + 1) * 5}m ago"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),


      body:  Column(
        children: [
          SizedBox(
            height: screenHeight * 0.6,
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05 ,top : screenHeight * 0.08) ,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                childAspectRatio: 1.1,
                children: [
                  ClickableCard(
                    mainText: "SURVEY",
                    page: Survey(),
                    subText: null,
                  ),
                  ClickableCard(
                    mainText: "SURVEY",
                    subText: "presentation",
                    page: Survey_presentation(),
                  ),

                  ClickableCard(
                    mainText: "QUIZ 01",
                    subText: null,
                    page: QuizT1(),
                  ),

                  ClickableCard(
                    mainText: "QUIZ 01",
                    subText: "presentation",
                    page: QuizT1_presentation(),
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(// To center the quiz 2 container
            offset: Offset(0, -70),
            child: Container(
                width: screenWidth * 0.4,
                height: screenHeight * 0.173,
              child:   ClickableCard(
                mainText: "QUIZ 02",
                subText: null,
                page: QuizT2(),
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.03),

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
        Text(title, style: TextStyle(fontFamily: "MontserratSemi", color : Color(0xff21334E),fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(height: 4),
        Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
        Divider(), // Adds a line between notifications
      ],
    ),
  );
}
