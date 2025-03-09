import 'package:flutter/material.dart';
import '../pages3/feedbacks.dart';
import '../pages3/quizzes.dart';
import '../pages3/results.dart';
import '../pages3/stats.dart';
import '../widgets/project_card.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFDFD),

      /*-----------------APPBAR------------------*/
      appBar: AppBar(
        backgroundColor: Colors.white,
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

                itemBuilder: (context) =>
                [
                  PopupMenuItem(
                    value: 'profile',
                    height: 60,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(
                            'images/people.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text("Profile",
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w500)
                        ),
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
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w500)),
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
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w500)),
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
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w500)),
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
                'images/bell1.png',
                width: 37,
                height: 37,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),

      /*----------------------MAIN-----------------------*/
      body: Padding(
        padding: const EdgeInsets.only(top: 35.0, left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: const Text(
                "Hi student !",
                style: TextStyle(
                  fontFamily: "RammettoOne",
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff21334E),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /*---------------SEARCH BAR---------------*/
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Circle around search icon
                        border: Border.all(color: Color(0xff87bcfe), width: 2),
                      ),
                      child: Icon(
                          Icons.search, color: Color(0xff87bcfe), size: 22),
                    ),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /*-----------------WELCOME CARD----------------*/
            Container(

              padding: const EdgeInsets.only(
                  top: 8, bottom: 8, left: 30, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xff21334E), width: 5),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),

              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome!",
                          style: TextStyle(
                            fontFamily: "RammettoOne",
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff21334E),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "Let’s get started on something amazing",
                          style: TextStyle(
                            fontFamily: "MontserratSemi",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2E63B3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        "images/girl.png", fit: BoxFit.contain,)
                  ),
                ],
              ),
            ),

            SizedBox(height: 25,),

            /*--------------ONGOING PROJECTS-----------------*/
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Ongoing projects",
                    style: TextStyle(
                      fontFamily: "Moul",
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff2E63B3),
                    ),
                  ),
                  Text(
                    "view all",
                    style: TextStyle(
                        fontFamily: "MontserratSemi",
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /*-----------------PROJECTS GRID------------------*/
            Expanded(
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 25,
                childAspectRatio: 1.1,
                children: [
                  ProjectCard(
                    imagePath: "images/illustration1.png",
                    text: "Quizzes and surveys",
                    defaultTextColor: Color(0xff21334E),
                    defaultColor: Color(0xffdff0ff),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Quizzes()),
                      );
                    },
                  ),
                  ProjectCard(
                    imagePath: "images/illustration2.png",
                    text: "Results and scores",
                    defaultTextColor: Color(0xff21334E),
                    defaultColor: Color(0xffdff0ff),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Results()),
                      );
                    },
                  ),
                  ProjectCard(
                    imagePath: "images/illustration3.png",
                    text: "Statistics",
                    defaultTextColor: Color(0xff21334E),
                    defaultColor: Color(0xffdff0ff),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Statistics()),
                      );
                    },
                  ),
                  ProjectCard(
                    imagePath: "images/illustration4.png",
                    text: "Feedback",
                    defaultTextColor: Color(0xff21334E),
                    defaultColor: Color(0xffdff0ff),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedbackPage()),
                      );
                    },
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
