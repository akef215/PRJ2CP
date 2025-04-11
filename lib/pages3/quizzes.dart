import 'package:esi_quiz/pages3/quizPages/Q1.dart';
import 'package:flutter/material.dart';

import '../pages2/agenda.dart';
import '../pages2/profile.dart';

class Quizzes extends StatefulWidget {
  const Quizzes({super.key});

  @override
  State<Quizzes> createState() => _QuizzesState();
}

class _QuizzesState extends State<Quizzes> {
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffDFF0FF),

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
                    'images/grid2.png',
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
                'images/bell2.png',
                width: 37,
                height: 37,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),

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
             Navigator.push(context, MaterialPageRoute(builder: (context) => Quiz1()));
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
