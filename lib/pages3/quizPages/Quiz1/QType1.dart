
import 'package:esi_quiz/widgets/appbar.dart';
import 'package:flutter/material.dart';

import '../../../pages2/agenda.dart';
import '../../../pages2/profile.dart';
import 'Qpage1.dart';



/// rediretion page
////START THE QUIZ
class QuizT1 extends StatefulWidget {
  const QuizT1({super.key});

  @override
  State<QuizT1> createState() => _QuizT1State();
}

class _QuizT1State extends State<QuizT1> {
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffDFF0FF),

      /*-----------------APPBAR------------------*/
      appBar: Custom_appBar().buildAppBar(context, "Quiz", true),


      body: Column(
        children: [
          Padding(
            /*------------------QUIZ IMAGE----------------------*/
            padding: EdgeInsets.only(left: 71, top: 130, right: 71, bottom: 15),
            child:
            Stack(
              alignment: Alignment.center ,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  height: screenHeight * 0.3 ,
                  width: screenWidth * 0.65 ,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22) ,
                    image: DecorationImage(
                      image : AssetImage("images/quizimg.png"),
                      fit: BoxFit.cover ,
                    ),
                  ),
                ),

                Image.asset(
                  "images/quizgirl.png" ,
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.4 ,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),

          SizedBox(height: 30) ,
          /*------------------START QUIZ BUTTON-------------------*/
          ElevatedButton(
            onPressed: () {
             // Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage1()));
            },
            style: ElevatedButton.styleFrom(
              elevation: 0.05,
              backgroundColor: Color(0xffFFFDFD) ,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              minimumSize: Size(180, 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: BorderSide(
                  color: Color(0xff0F3D64) ,
                  width: 5 ,
                ),
              ),
            ),
            child: Text(
              "Start the Quiz",
              style: TextStyle(
                  color: Color(0xff21334E),
                  fontFamily: "RammettoOne",
                  fontSize: 16 ,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),



          /*-----------------BACK ARROW----------------------*/
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 15),
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
          ),
        ],
      ),
    );
  }
}

