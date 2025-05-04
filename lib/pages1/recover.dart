import 'package:flutter/material.dart';
import '../pages2/homePage.dart';
import 'dart:async';

import 'createAcc2_1.dart';


class Recover extends StatefulWidget {
  const Recover({super.key});

  @override
  State<Recover> createState() => _RecoverState();
}

class _RecoverState extends State<Recover> {

  /*------------RETRIEVE USER'S INPUT VARIABLES--------------*/
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();


  String? _emailError;
  String? _codeError;

  /*------------VERIFICATION METHODS--------------*/
  // Validate email format
  String? validateEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@esi\.dz$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(email)) {
      return null; // valid email
    } else {
      return 'Please enter a valid ESI email address';
    }
  }

  // Code validation
  String? validateCode(String code) {
    if (code.isEmpty) {
      return 'Please enter the verification code';
    }
    return null; // Valid code
  }

  /*--------COUNTDOWN VARS------------*/
  bool isWaiting = false;
  int countdown = 30;// A countdown of 30s
  Timer? _timer;
  String buttonText = "Send Code"; // Initially "Send Code"

  // Method for a countdown
  void startCountdown() {
    setState(() {
      isWaiting = true;
      countdown = 30;
      buttonText = "Resend Code"; // Change text after we click on "send code"
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          isWaiting = false; // Enable button after countdown
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        /*---------------BACKGROUND----------------*/
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),

            /*---------------FOREGROUND----------------*/
            /*-------------MAIN BOX-------------*/
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),

                child: Container(/*-------------MAIN BOX-------------*/
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.8,
                    maxWidth: screenWidth * 0.85,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 70.0),
                  margin: EdgeInsets.fromLTRB(35.0, 100.0, 35.0, 100.0),
                  decoration: BoxDecoration(
                    color: Color(0xff21334e),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 160),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Recover Account',
                      style: TextStyle(
                        fontFamily: "RammettoOne",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(/*-----------EMAIL BOX-------------*/
                        padding: const EdgeInsets.only(left: 18.0, bottom: 8.0),
                        child: Text(
                          'Esi.dz email',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Container(
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.09,
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Color(0xffc8e5ff),
                          borderRadius: BorderRadius.circular(25.0),
                        ),

                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) { // Checking email format while inputting
                              setState(() {
                                _emailError = validateEmail(value);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Enter your esi.dz email",
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.email, color: Colors.grey[400]),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            ),
                          ),
                        ),
                      ),
                      // Display error message for email field
                      if (_emailError != null)
                        Padding(
                          padding: EdgeInsets.only(left: 12.0, top: 3.0),
                          child: Text(
                            _emailError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      SizedBox(height: 40.0),

                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, bottom: 8.0),
                        child: Text(
                          'Verification code',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Container(/*---------VERIFICATION CODE BOX----------*/
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.09,
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Color(0xffc8e5ff),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              Expanded( // Prevents shrinking of TextField
                                child: TextField(
                                  controller: codeController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Enter code",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 15,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Stack( // Setting send code button ON TextField
                                alignment: Alignment.center,
                                children: [
                                  if (isWaiting) // Circular countdown of 30s
                                    SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        value: 1 - (countdown / 30),
                                        strokeWidth: 3,
                                        color: Color(0xff21334e),
                                      ),
                                    ),
                                  TextButton(
                                    onPressed: isWaiting ? null : startCountdown, // Disable resend code button during the countdown
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: isWaiting // Depends on isWaiting value
                                        ? Text(
                                      "$countdown",
                                      style: TextStyle(color: Color(0xff21334e), fontSize: 13, fontWeight: FontWeight.bold),
                                    )
                                        : Text(
                                      buttonText, //  "Resend Code"
                                      style: TextStyle(color: Color(0xff21334e), fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),



                  SizedBox(height: 70.0),
                  /*---------------LOGIN BUTTON--------------*/
                  Container(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.095,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                    ),

                    child: ElevatedButton(
                      onPressed: (){
                        //TODO: CHECK EMPTY FIELDS
                        //TODO: LOGIN LOGIC
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffc8e5ff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        padding: EdgeInsets.all(8),
                        elevation: 0.4, // Shadow
                      ),
                      child: Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontFamily: "RammettoOne",
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff21334e),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //
                  // SizedBox(height: 12.0,),
                  // Row(/*-----------DONT HAVE AN ACCOUNT?-------------*/
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Text(
                  //       "Don't have an account? " ,
                  //       style: TextStyle(
                  //         color: Colors.white ,
                  //         // fontFamily: "Montserrat" ,
                  //         fontSize: 12.0 ,
                  //       ),
                  //     ),
                  //
                  //     GestureDetector(
                  //       onTap: (){
                  //         Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAcc2()));
                  //       },
                  //       child: Text(
                  //         'Create Account' ,
                  //         style: TextStyle(
                  //           color: Colors.blueAccent,
                  //           fontSize: 12.0 ,
                  //           decoration: TextDecoration.underline ,
                  //           decorationColor: Colors.blueAccent,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
