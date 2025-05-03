import 'dart:convert';

import 'package:esi_quiz/pages3/quizPages/quizChoice.dart';
import 'package:esi_quiz/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../pages3/feedbacks.dart';
import '../pages3/quizzes.dart';
import '../pages3/results.dart';
import '../pages3/stats.dart';
import '../widgets/project_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final FocusNode _focusNode = FocusNode();

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> filteredItems = [];
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> submittedItemsForSearch = [];
  FocusNode _focusNode = FocusNode();


  String? _studentId;
  int? _latestSurveyId;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStudentIdAndLatestSurveyId();
    _loadSubmittedItems() ;
  }

  Future<void> _loadSubmittedItems() async {
    final prefs = await SharedPreferences.getInstance();
    _studentId = prefs.getString('studentId');
    if (_studentId != null) {
      try {
        final quizResponse = await http.get(Uri.parse('$path/quizzes/submitted/quizzes/?student_id=${Uri.encodeComponent(_studentId!)}'));
        final surveyResponse = await http.get(Uri.parse('$path/quizzes/submitted/surveys/?student_id=${Uri.encodeComponent(_studentId!)}'));
        List<Map<String, dynamic>> items = [];
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
            submittedItemsForSearch = items;
            filteredItems = [...submittedItemsForSearch]; // Initialize filtered list
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

  //Get the latest survey id from student id
  Future<void> _loadStudentIdAndLatestSurveyId() async {
    final prefs = await SharedPreferences.getInstance();
    _studentId = prefs.getString('studentId');
    if (_studentId != null) {
      print('Student ID: $_studentId');
      await _fetchLatestSurveyId(_studentId!);
    } else {
      setState(() {
        _errorMessage = "No student ID found!";
        _isLoading = false;
      });
      print("❌ No student ID found!");
    }
  }


  //function to get all the submitted surveys
  Future<List<int>> fetchSubmittedSurveysOnly(String studentId) async {
    print('Fetching submitted surveys for studentId: $studentId');
    final encodedId = Uri.encodeComponent(studentId); // encodes '24/0006' to '24%2F0006'
    final url = Uri.parse(path + '/quizzes/submitted/surveys/?student_id=$encodedId');

    try {
      final response = await http.get(url);

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        // Extract only the IDs from the list
        List<int> submittedSurveyIds = data.map<int>((survey) => survey['id'] as int).toList();

        print('Submitted survey IDs: $submittedSurveyIds');
        return submittedSurveyIds;
      } else {
        print('❌ Failed to load submitted surveys');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching submitted surveys: $e');
      return [];
    }
  }


  //loading the ID of the last survey
  Future<void> _fetchLatestSurveyId(String studentId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<int> submittedIds = await fetchSubmittedSurveysOnly(studentId);
      if (submittedIds.isNotEmpty) {
        setState(() {
          _latestSurveyId = submittedIds.last;
          print('$_latestSurveyId');
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = "Error loading latest survey ID: $error";
      });
      print("Error loading latest survey ID: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterItems(String query) {
    print('Search Query: $query');
    print('Submitted Items before filter: $submittedItemsForSearch');
    setState(() {
      filteredItems = submittedItemsForSearch
          .where((item) =>
          item['type']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      print('Filtered Items after filter: $filteredItems');
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
            filteredItems = submittedItemsForSearch;
            _focusNode.unfocus(); // Remove focus from the search field
          });
          return false; // Prevent default back navigation
        }
        return true; // Allow default back behavior
      },
      child: Scaffold(
        backgroundColor: Color(0xffFFFDFD),

        /*-----------------APPBAR------------------*/
        appBar: Custom_appBar().buildAppBar(context, "Home", true),

        /*----------------------MAIN-----------------------*/
        body: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.04,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
          ),
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
                  onChanged: _filterItems,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        width: screenWidth * 0.07,
                        height: screenHeight * 0.035,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Circle around search icon
                          border: Border.all(
                            color: Color(0xff87bcfe),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Color(0xff87bcfe),
                          size: 22,
                        ),
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
                    top: 8,
                    bottom: 8,
                    left: 30,
                    right: 15,
                  ),
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
                            SizedBox(height: 10),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.asset(
                            "images/girl.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

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
                            MaterialPageRoute(
                              builder: (context) => QuizChoice(),
                            ),
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
                            MaterialPageRoute(
                              builder: (context) => ResultsPage(),
                            ),
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
                            MaterialPageRoute(
                              builder: (context) => Statistics(surveyId: _latestSurveyId),
                            ),
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
                            MaterialPageRoute(
                              builder: (context) => FeedbackPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ] else if (_searchController.text.isNotEmpty) ...[
                // We show filtered quizzes
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      var item = filteredItems[index];
                      return quizBox( // Use your quizBox widget
                        context: context,
                        item: item, // Pass the entire item map
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
                                builder: (context) => Statistics(surveyId: null),
                              ),
                            );
                          }
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
