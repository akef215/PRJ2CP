import 'dart:convert';

import 'package:esi_quiz/pages3/resultsPage/reviewPage.dart';
import 'package:esi_quiz/pages3/stats.dart';
import 'package:esi_quiz/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../pages1/logMobile.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsState();
}


class _ResultsState extends State<ResultsPage> {

  List<Map<String, dynamic>> submittedItems = [];
  bool _isLoading = true;
  String? _studentId;

  @override
  void initState() {
    super.initState();
    _loadSubmittedItems();
  }

  Future<void> _loadSubmittedItems() async {
    final prefs = await SharedPreferences.getInstance();
    _studentId = prefs.getString('studentId');
    if (_studentId != null) {
      try {
        final quizResponse = await http.get(Uri.parse('$path/quizzes/submitted/quizzes/?student_id=${Uri.encodeComponent(_studentId!)}'));
        final surveyResponse = await http.get(Uri.parse('$path/quizzes/submitted/surveys/?student_id=${Uri.encodeComponent(_studentId!)}'));

        print('--- Quiz Response ---');
        print('Status Code: ${quizResponse.statusCode}');
        print('Body: ${quizResponse.body}');
        print('--- Survey Response ---');
        print('Status Code: ${surveyResponse.statusCode}');
        print('Body: ${surveyResponse.body}');

        if (quizResponse.statusCode == 200 && surveyResponse.statusCode == 200) {
          final List<dynamic> quizData = jsonDecode(quizResponse.body);
          final List<dynamic> surveyData = jsonDecode(surveyResponse.body);

          List<Map<String, dynamic>> items = [];

          for (var quiz in quizData) {
            items.add({
              'id': quiz['id'],
              'title': quiz['title'],
              'date': quiz['date'],
              'module_code': quiz['module_code'],
              'type': 'quiz',
              'type_quizz': quiz['type_quizz'],
            });
          }

          for (var survey in surveyData) {
            items.add({
              'id': survey['id'],
              'title': survey['title'],
              'date': survey['date'],
              'module_code': survey['module_code'],
              'type': 'survey',
              'type_quizz': survey['type_quizz'], // Let's also include the raw type from the backend
            });
          }

          setState(() {
            submittedItems = items;
            _isLoading = false;
          });
        } else {
          print('Failed to load submitted items. Quiz status: ${quizResponse.statusCode}, Survey status: ${surveyResponse.statusCode}');
          setState(() {
            _isLoading = false;
            // Optionally show an error message
          });
        }
      } catch (e) {
        print('Error loading submitted items: $e');
        setState(() {
          _isLoading = false;
          // Optionally show an error message
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        // Optionally show a "No student ID" message
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchUserAnswersForQuiz(String quizId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentId = prefs.getString('studentId'); // Assuming you stored studentId

    if (studentId == null) {
      // Handle the case where student ID is not available
      print('Error: Student ID not found.');
      return [];
    }

    final Uri url = Uri.parse(
      '$path/students/$studentId/quizzes/$quizId/answers', // Replace with your actual backend endpoint
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $bearerToken'}, // Assuming you have the token
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        // Assuming the backend returns the answers in the correct format
        return responseData.cast<Map<String, dynamic>>().toList();
      } else {
        print('Failed to fetch user answers. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error fetching user answers: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print("results");
    return Scaffold(
      appBar: Custom_appBar().buildAppBar(context, "Results", false),

      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Dark Blue Background
          Container(height: screenHeight, color: Color(0xff21334E)),

          // Light blue
          Positioned.fill(
            child: ClipPath(
              clipper: DiagonalClipper(),
              child: Container(color: Color(0xffC8E5FF)),
            ),
          ),

          // Results and Scores Container
          Positioned(
            top: screenHeight * 0.11,
            left: screenWidth * 0.2,
            right: screenWidth * 0.2,
            child: Container(
              height: screenHeight * 0.22,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Color(0xff21334E), width: 10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "images/illustration2_1.png",
                    height: 100,
                  ), // Add your image
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    "Results and Scores",
                    style: TextStyle(
                      fontFamily: "RammettoOne",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff21334E),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Quiz Boxes
          Positioned(
            /*------------SCROLLABLE SECTION------------*/
            top: screenHeight * 0.35,
            child: SizedBox(
              height: screenHeight * 0.52,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: submittedItems.map((item) { // Use submittedItems
                    return InkWell(
                      onTap: () {
                        if (item['type'] == 'quiz') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizReviewPage(quizId: item['id'].toString()),
                            ),
                          );
                        } else {
                          // Handle navigation for surveys if needed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Statistics(surveyId: item['id']),
                            ),
                          );
                        }
                      },
                      child: quizBox(
                        context: context,
                        item: item, // Pass the entire item
                        onCheckStats: () {
                          if (item['type_quizz'] == 'S') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Statistics(surveyId: item['id']),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Statistics(surveyId: null), // Navigate to quiz tab
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // Back Arrow
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Go back to previous page
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        height: 37,
                        width: 37,
                        child: Image.asset(
                          "images/left-arrow (1).png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontFamily: "MontserratSemi",
                          color: Colors.grey[400],
                          fontSize: 18,
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

// Custom Clipper to Create Diagonal Effect
class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height * 0.3); // Diagonal line down
    path.lineTo(0, size.height); // Go straight down
    path.lineTo(0, size.height); // Go left
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
Widget quizBox({
  required BuildContext context,
  required Map<String, dynamic> item, // Receive the item data
  required VoidCallback onCheckStats,
}) {
  print('QuizBox Item: $item');
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  String title = '${item['module_code'] ?? 'Unknown'} ';
  String typeText = '';
  if (item['type_quizz'] == '1' || item['type_quizz'] == '2') {
    typeText = 'Quiz ';
  } else if (item['type_quizz'] == 'S') {
    typeText = 'Survey ';
  }
  title += '#${item['id'] ?? 'Unknown'}';

  return Container(
    width: screenWidth * 0.8,
    height: screenHeight * 0.14, // Increased height if needed for the type text
    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 8),
    padding: EdgeInsets.only(top: 15, bottom: 10, right: 15, left: 40),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: "RammettoOne",
                  color: Color(0xff21334E),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 3),
              Text(
                typeText, // Display "Quiz" or "Survey"
                style: TextStyle(
                  fontFamily: "MontserratSemi",
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 3),
              Text(
                item['date'] ?? 'Unknown Date',
                style: TextStyle(
                  fontFamily: "MontserratSemi",
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: screenHeight * 0.07,
          width: screenWidth * 0.22,
          child: ElevatedButton(
            onPressed: onCheckStats,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffC8E5FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Check Stats",
              style: TextStyle(fontSize: 12, color: Color(0xff21334E)),
            ),
          ),
        ),
      ],
    ),
  );
}