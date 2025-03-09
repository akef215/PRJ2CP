import 'package:flutter/material.dart';

import '../pages2/profile.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackState();

}

class _FeedbackState extends State<FeedbackPage> {


  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


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
                   // Navigator.pushNamed(context, '/profile');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  } else if (value == 'modules') {
                    Navigator.pushNamed(context, '/modules');
                  } else if (value == 'agenda') {
                    Navigator.pushNamed(context, '/agenda');
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
            //TODO: MAKE IT A CLICKABLE BUTTON
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Image.asset(
                'images/bell1.png',
                width: 37,
                height: 37,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              /*------------------FEEDBACK IMAGE----------------------*/
              padding: EdgeInsets.only(left: 71, top: 35, right: 71, bottom: 15),
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
                          borderRadius: BorderRadius.circular(30) ,
                          image: DecorationImage(
                            image : AssetImage("images/container.png"),
                            fit: BoxFit.cover ,
                          ),
                        ),
                      ),
        
                      Image.asset(
                        "images/feedback.png" ,
                        height: screenHeight * 0.3,
                        width: screenWidth * 0.48 ,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
            ),
        
            /*-----------------FEEDBACK LABEL--------------------*/
            const Text(
              "Describe your feedback in detail :",
              style: TextStyle(
                fontFamily: "MontserratSemi",
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
        
            SizedBox(height: 30),
        
            // ----------- INPUT BOX -----------------
            Container(
              height: screenHeight * 0.22 ,
              width: screenWidth * 0.78,
              decoration: BoxDecoration(
                  color: Colors.white ,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xffC8E5FF) , width : 5)
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                controller: feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Enter here..................",
                  hintStyle: TextStyle(
                    color : Colors.grey[400],
                    fontFamily: "MontserratSemi",
                    fontSize: 14 ,
                    fontWeight: FontWeight.w600 ,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 40 ),

            /*------------------SUBMIT BUTTON-------------------*/
            ElevatedButton(
              onPressed: () { // When pressing submit we check feeback field state
                String feedback = feedbackController.text ;
                if (feedback.isNotEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Feedback submitted successfully!",
                      style: TextStyle(color: Colors.grey[600] ),
                      ),
                      backgroundColor: Color(0xffC8E5FF),
                    ),
                  );
                  feedbackController.clear();
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please enter your feedback.",
                          style: TextStyle(color: Colors.grey[600] ),
                      ),
                      backgroundColor: Color(0xffC8E5FF),
                    ),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                elevation: 0.2,
                backgroundColor: Color(0xffC8E5FF) ,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                minimumSize: Size(144, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: Colors.white ,
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

            SizedBox(height: 40,) ,

            /*-----------------BACK ARROW----------------------*/
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
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
      ),
      
    );
  }
}
