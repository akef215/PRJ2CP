import 'package:flutter/material.dart';
import 'continue.dart';

class CreateAcc2 extends StatefulWidget {
  const CreateAcc2({super.key});

  @override
  State<CreateAcc2> createState() => _CreateAccState();
}

class _CreateAccState extends State<CreateAcc2> {


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents shift when keyboard appears
      body: SizedBox(
        /*---------------BACKGROUND----------------*/
        height: screenHeight, // Make it full screen
        width: screenWidth,
        child: Stack(// Used for overlapping
          clipBehavior: Clip.none, // Allows the image to go outside the box if needed

          children: [
            Positioned.fill(
              child: Image.asset(
                'images/background.jpg',
                fit : BoxFit.cover , // Fill the screen while preventing streches
              ),
            ),

            /*---------------FOREGROUND----------------*/

            Align(// Makes sure Container is in the center of stack
              alignment: Alignment.center,
              child: SingleChildScrollView( // Ensures UI not shrinking when keyboard shows
                physics: NeverScrollableScrollPhysics(), // Prevents user scrolling


                child: Container(  /*-------------MAIN BOX-------------*/
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.86, // Prevents shrinking
                    maxWidth: screenWidth * 0.85,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 70.0),
                  margin: EdgeInsets.fromLTRB(35.0, 80.0, 35.0, 80.0),
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
                mainAxisSize: MainAxisSize.min, // Wrap content height
                children: [
                  SizedBox(height: 110), // Push text down
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Create a new account' ,
                      style: TextStyle(
                        fontFamily: "RammettoOne" ,
                        fontSize: 16 ,
                        fontWeight: FontWeight.w500 ,
                        color: Colors.white ,
                      ),
                    ),
                  ),

                  SizedBox(height: 45.0,),
                  Column(/*-------------INFORMATION COLUMN-------------*/
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0 , bottom: 8.0),
                        child: Text(
                          'Full Name' ,
                          style: TextStyle(
                            fontFamily: "Montserrat" ,
                            fontSize: 14 ,
                            fontWeight: FontWeight.w500 ,
                            color: Colors.white ,
                          ),
                        ),
                      ),

                      Container(/*---------Full Name BOX----------*/
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.08,

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
                            //TODO : ADD VERIFICATION FOR EMPTY FIELD
                            style: TextStyle(color: Colors.black), // User input text black
                            decoration: InputDecoration(
                              hintText: "Enter your full name" ,
                              hintStyle: TextStyle(
                                color: Colors.grey[500] ,
                                fontSize: 15 ,
                              ),
                              border: InputBorder.none, // Removes the default black line
                              suffixIcon: Icon(Icons.person, color: Colors.grey[400],), // Person icon on the right
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0) ,
                            ),
                          ),

                        ),
                      ),


                      SizedBox(height: 50.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0 , bottom: 8.0),
                        child: Text(
                          'Level' ,
                          style: TextStyle(
                            fontFamily: "Montserrat" ,
                            fontSize: 14 ,
                            fontWeight: FontWeight.w500 ,
                            color: Colors.white ,
                          ),
                        ),
                      ),

                      Container(/*---------Level BOX----------*/
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.08,

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
                            //TODO : MAKE IT A SELECT OPTION - LIST OF OPTIONS + DROPDOWN BUTTON
                            style: TextStyle(color: Colors.black), // User input text black
                            decoration: InputDecoration(
                              hintText: "Select your level" ,
                              hintStyle: TextStyle(
                                color: Colors.grey[500] ,
                                fontSize: 15 ,
                              ),
                              border: InputBorder.none, // Removes the default black line of TextField

                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0) ,
                            ),
                          ),
                        ),
                      ),


                      SizedBox(height: 50.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0 , bottom: 8.0),
                        child: Text(
                          'Group Number' ,
                          style: TextStyle(
                            fontFamily: "Montserrat" ,
                            fontSize: 14 ,
                            fontWeight: FontWeight.w500 ,
                            color: Colors.white ,
                          ),
                        ),
                      ),

                      Container(/*---------GROUP NB BOX----------*/
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.08,

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
                            // TODO: MAKE IT A SELECT OPTION - BASING ON LEVEL
                            style: TextStyle(color: Colors.black), // User input text black
                            decoration: InputDecoration(
                              hintText: "Select your group number" ,
                              hintStyle: TextStyle(
                                color: Colors.grey[500] ,
                                fontSize: 15 ,
                              ),
                              border: InputBorder.none, // Removes the default black line of TextField
                              //    suffixIcon: Icon(Icons.group , color: Colors.grey[400],),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0) ,
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),


                  SizedBox(height: 40.0,),
                  Container(/*------------CONTINUE BOX------------*/
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.095,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.circular(40.0),
                    ),

                    child: ElevatedButton(
                      onPressed: (){
                        // TODO :  _validateForm();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Continue()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffc8e5ff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        padding: EdgeInsets.all(8),
                        elevation: 0.4, // Shadow
                      ),

                      child:Center(
                        child: Text(
                          'Continue' ,
                          style: TextStyle(
                            fontFamily: "RammettoOne" ,
                            fontSize: 18 ,
                            fontWeight: FontWeight.w500 ,
                            color: Color(0xff21334e),
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
    );
  }
}
