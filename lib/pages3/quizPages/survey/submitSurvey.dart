import 'package:flutter/material.dart';

import '../../../widgets/appbar.dart';


class SubmitSurvey extends StatefulWidget {
  const SubmitSurvey({super.key});

  @override
  State<SubmitSurvey> createState() => _SubmitSurveyState();
}

class _SubmitSurveyState extends State<SubmitSurvey> {
  // TODO : Constructor will receive the number of questions and what questions were answered
  final int totalQuestions = 16;
  List<int> answeredQuestions = [2, 5 ,6, 8, 11 ,14]; // To simulate the question indexes

  bool isAnswered(int index) {
    return answeredQuestions.contains(index);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      backgroundColor: Colors.white,
      appBar: Custom_appBar().buildAppBar(context, "Submit", true),

      /*----------------------------MAIN--------------------------*/
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.07),
            child: Center(
              child: Wrap( /*-----------------ANSWERS LIST------------------*/
                spacing: 20,
                runSpacing: 25,
                children: List.generate(
                  totalQuestions,
                      (index) => Container(
                    width: screenWidth * 0.13,
                    height: screenHeight * 0.075,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isAnswered(index) ? Color(0xff0F3D64) : Colors.white,
                      border: Border.all(color: Color(0xff0F3D64), width: 3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontFamily: "RammettoOne",
                        color: isAnswered(index) ? Colors.white : Color(0xff0F3D64),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Are you sure about your answers ?",
              style: TextStyle(
                fontFamily: "MontserratSemi",
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xff4C7090),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 30),

          /*------------------SUBMIT BUTTON-------------------*/
          ElevatedButton(
            onPressed: () { },

            style: ElevatedButton.styleFrom(
              elevation: 0.2,
              backgroundColor: Color(0xffDCEEFE) ,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              minimumSize: Size(200, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: Color(0xff0F3D64) ,
                  width: 5 ,
                ),
              ),
            ),
            child: Text(
              "Submit",
              style: TextStyle(
                  color: Color(0xff21334E),
                  fontFamily: "RammettoOne",
                  fontSize: 16 ,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),

          /*-----------------BACK ARROW----------------------*/
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 65, left: 20, bottom: 10),
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
