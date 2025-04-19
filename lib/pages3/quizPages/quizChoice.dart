import 'package:esi_quiz/pages3/quizPages/Quiz1WP/QType1_presentation.dart';
import 'package:esi_quiz/pages3/quizPages/survey/survey.dart';
import 'package:esi_quiz/pages3/quizPages/surveryWP/survey_presentation.dart';

import 'package:flutter/material.dart';

import '../../widgets/clickable_card.dart';
import 'Quiz1/QType1.dart';
import 'Quiz2/QType2.dart';
import '../../widgets/appbar.dart';


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
      appBar: Custom_appBar().buildAppBar(context, "Quiz", false),

      
      
      
      /*-----------------BODY------------------*/
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
