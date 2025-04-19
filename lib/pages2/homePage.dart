import 'package:esi_quiz/pages3/quizPages/quizChoice.dart';
import 'package:esi_quiz/widgets/appbar.dart';
import 'package:flutter/material.dart';
import '../pages3/feedbacks.dart';
import '../pages3/quizzes.dart';
import '../pages3/results.dart';
import '../pages3/stats.dart';
import '../widgets/project_card.dart';
import 'agenda.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final FocusNode _focusNode = FocusNode();

class _HomePageState extends State<HomePage> {

  TextEditingController _searchController = TextEditingController();

  //TODO : THESE WILL BE FETCHED FROM BACKEND ?
  List<Map<String, String>> allQuizzes = [
    {"title": "Quiz 1", "date": "2025-01-01"},
    {"title": "Quiz 2", "date": "2025-02-01"},
    {"title": "Survey 1", "date": "2025-03-01"},
    {"title": "Quiz 3", "date": "2025-04-01"},
    // Add more quizzes/surveys
  ];

  List<Map<String, String>> filteredQuizzes = [];

  @override
  void initState() {
    super.initState();
    filteredQuizzes = allQuizzes; // Initially, show all quizzes
  }

  
  void _filterQuizzes(String query) {
    setState(() {
      filteredQuizzes = allQuizzes
          .where((quiz) => quiz['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (_searchController.text.isNotEmpty || _focusNode.hasFocus) {
          setState(() {
            _searchController.clear();
            filteredQuizzes = allQuizzes;
            _focusNode.unfocus(); // Remove focus from the search field
          });
          return false; // Prevent default back navigation
        }
        return true; // Allow default back behavior
      },
      child: Scaffold(
        backgroundColor: Color(0xffFFFDFD),
      
        /*-----------------APPBAR------------------*/
        appBar: Custom_appBar(),
      
        /*----------------------MAIN-----------------------*/
        body: Padding(
          padding:  EdgeInsets.only(top: screenHeight * 0.04, left: screenWidth * 0.05, right: screenWidth * 0.05),
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
      
              SizedBox(height: screenHeight * 0.018),
      
              /*---------------SEARCH BAR---------------*/
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterQuizzes,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        width: screenWidth * 0.07,
                        height: screenHeight * 0.035,
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
      
      
          if (_searchController.text.isEmpty && !_focusNode.hasFocus) ...[
              SizedBox(height: screenHeight * 0.03),
      
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
      
              SizedBox(height: screenHeight * 0.03,),
      
              /*--------------ONGOING PROJECTS-----------------*/
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  "What do you need",
                  style: TextStyle(
                    fontFamily: "Moul",
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff0F3D64),
                  ),
                ),
              ),
               SizedBox(height: screenHeight * 0.025),
      
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
                          MaterialPageRoute(builder: (context) => QuizChoice()),
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
                          MaterialPageRoute(builder: (context) => ResultsPage()),
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
           ]
          else if (_searchController.text.isNotEmpty) ...[
            // We show filtered quizzes
            Expanded(
              child: ListView.builder(
                itemCount: filteredQuizzes.length,
                itemBuilder: (context, index) {
                  var quiz = filteredQuizzes[index];
                  return quizBox(
                    context: context,
                    title: quiz['title']!,
                    date: quiz['date']!,
                    onCheckStats: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Statistics()),
                      );
                    },
                  );
                },
              ),
            ),
          ] else ...[
            //  If search is empty but still focused we show "no results"
            Expanded(
              child: Center(
                child: Text(
                  "No results found",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "MontserratSemi",
                    color: Color(0xff21334E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
           ],
          ),
        ),
      ),
    );
  }
}
