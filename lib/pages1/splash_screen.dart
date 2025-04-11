import 'package:esi_quiz/pages1/firstPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void initState() {
    super.initState();

    // Wait for 10 seconds then navigate to the main screen
    Timer(Duration(seconds: 5), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => FirstPage()));
    });
  }

  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffCAE6FE),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Padding(
               padding: EdgeInsets.only(top : screenHeight * 0.15),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Image.asset(
                     "images/logo_esi.png",
                     height: 150,
                     width: 150,
                   ),

                   Text(
                     "QUIZ",
                     style: TextStyle(
                       fontFamily: "Monoton",
                       fontSize: 36,
                       fontWeight: FontWeight.w400 ,
                       color: Color(0xff21334E),
                     ),
                   ),

                 ],
               ),
             ),

            SizedBox(height: screenHeight * 0.1 ),
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                "LOADING ...",
                style: TextStyle(
                  fontFamily: "MontserratThin" ,
                  fontWeight: FontWeight.w400 ,
                  fontSize: 36 ,
                  color: Color(0xff21334E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
