import 'package:esi_quiz/pages3/results.dart';
import 'package:esi_quiz/pages3/statsPages/surveyStatQ.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SurveyStats extends StatefulWidget {
  const SurveyStats({super.key});

  @override
  State<SurveyStats> createState() => _SurveyStatsState();
}

class _SurveyStatsState extends State<SurveyStats> {
  late Future<List<Map<String, dynamic>>> surveyData;


  @override
  void initState() {
    super.initState();
    loadStudentIdAndSurvey();

  }


  void loadStudentIdAndSurvey() async {
    final prefs = await SharedPreferences.getInstance();
    String? studentId = prefs.getString('studentId');
    if (studentId != null) {
      print('Student ID: $studentId');
      surveyData = loadLatestSurvey(studentId);
    } else {
      print("❌ No student ID found!");
    }
  }


  //get all the submitted quizzes
  Future<List<Map<String, dynamic>>> fetchSubmittedQuizzes(String studentId) async {
    final response = await http.get(
      Uri.parse('http://192.168.10.146:8000/quizzes/submitted/$studentId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> quizIds = json.decode(response.body);
      List<Map<String, dynamic>> submittedQuizzes = [];

      for (var id in quizIds) {
        final quizData = await fetchSurveyData(id);
        submittedQuizzes.add({
          'surveyId': id,
          'questions': quizData, //List<Map<String, dynamic>>
        });

      }

      return submittedQuizzes;
    } else {
      throw Exception('Failed to fetch submitted quizzes');
    }
  }

  //A fake function to text since i do not have submit option
  // Future<List<dynamic>> fetchSubmittedQuizzesOnly(String studentId) async {
  //   print('Fetching quizzes for studentId: $studentId');
  //
  //   // Mock data or real API call
  //   // For now, we return an empty list or mock data for testing
  //   List<dynamic> submittedQuizzes = [1, 2, 3];  // Example of mock IDs
  //
  //   // Log the data being returned
  //   print('Submitted quizzes: $submittedQuizzes');
  //
  //   return submittedQuizzes; // Should return the actual list of survey IDs
  // }

  // get the submitted quizzes
  Future<List<dynamic>> fetchSubmittedQuizzesOnly(String studentId) async {
    final response = await http.get(
      Uri.parse('http://192.168.10.146:8000/quizzes/submitted/$studentId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // list of survey IDs
    } else {
      throw Exception('Failed to fetch submitted survey IDs');
    }
  }


  bool isLoading = true; // This will track whether the data is loading

  //loading the last survey
  Future<List<Map<String, dynamic>>> loadLatestSurvey(String studentId) async {
    setState(() {
      isLoading = true; // Set to true when starting to load data
    });

    try {
      List<dynamic> submittedIds = await fetchSubmittedQuizzesOnly(studentId);

      if (submittedIds.isEmpty) {
        setState(() {
          isLoading = false; // Done loading and no data found
        });
        return []; // No quizzes submitted yet
      }

      int latestId = submittedIds.last; // Assuming the last one is the most recent
      List<Map<String, dynamic>> surveyData = await fetchSurveyData(latestId);

      setState(() {
        isLoading = false; // Done loading
      });

      return surveyData; // Return the survey data
    } catch (error) {
      setState(() {
        isLoading = false; // Done loading even if there was an error
      });

      // Log or handle the error, depending on your needs
      print("Error loading survey data: $error");

      // Optionally return an empty list or an error message in the UI
      return []; // You can choose to return an empty list or rethrow the error
    }
  }


  //
  // A fake once since i do no have the option to submit my answers
  // Future<List<Map<String, dynamic>>> fetchSurveyData(int surveyId) async {
  //   // For testing purposes, use the following hardcoded data instead of fetching from the API
  //   return [
  //     {
  //       'question_id': 'what does html stands for?',
  //       'choices': [
  //         {'choice_id': 'Hyper-Text Marketing Language', 'count': 5},
  //         {'choice_id': 'Hyper Text Markup Language', 'count': 10},
  //       ],
  //     },
  //   ];
  // }

  //correct one :expected to return smth like this function above
  Future<List<Map<String, dynamic>>> fetchSurveyData(int surveyId) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.10.146:8000/statistics/surveys/$surveyId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        return data.map((question) {
          return {
            'question': question['question_id'], // This is actually the question text
            'choices': List<Map<String, dynamic>>.from(
                question['choices'].map((choice) => {
                  'choice': choice['choice_id'],
                  'count': choice['count'],
                })
            )
          };
        }).toList();
      } else {
        throw Exception('Failed to load survey data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("Error fetching survey data: $e");
      rethrow;
    }
  }

  int selectedSection = -1; // No section selected initially

  // Function to create PieChart sections
  PieChartSectionData pieSection(int count, int total, Color color, int index) {
    bool isSelected = index == selectedSection; // Check if this section is selected
    return PieChartSectionData(
      value: (count / total) * 100,
      color: color,
      radius: isSelected ? 57 : 50, // Make the selected section larger
      title: '',
      showTitle: false,
      borderSide: isSelected
          ? BorderSide(
        color: Colors.grey.withOpacity(0.6), // Grey/transparent border
        width: 4, // Thicker border
      )
          : BorderSide.none, // No border for unselected sections
    );
  }

  List<Color> generateColors(int count) {
    return List.generate(count, (index) {
      final hue = (360 / count) * index;
      return HSLColor.fromAHSL(1.0, hue, 0.6, 0.6).toColor();
    });
  }


  double _getSelectedSectionPercentage(int index, List<int> counts, int totalVotes) {
    if (index >= 0 && index < counts.length) {
      return (counts[index] / totalVotes) * 100;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,

      body: isLoading
          ? Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0F3D64)),
        strokeWidth: 5.0,
      ),
      ) // Show loading indicator
          : FutureBuilder(
          future: surveyData,
          builder: (context, snapshot)
          {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0F3D64)),
                      strokeWidth: 5.0,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Loading survey statistics...',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'MontserratSemi',
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }


            if (snapshot.hasError) { //if there is an error fetching data
              return Center(child: Text('Error loading data'));
            }

            final colorList = [
              Color(0xFF0f3d64),
              Color(0xFF9ac7c4),
              Color(0xFFbfe1ff),
            ];
            final data = snapshot.data!;

            return
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.05),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ResultsPage()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "See more",
                            style: TextStyle(
                              fontFamily: "MontserratSemi",
                              color: Color(0x7f21334E),
                              fontSize: 12 ,
                            ),
                          ),

                          SizedBox(width: 2),
                          Transform.rotate(
                            angle: 3.1416, // Rotate 180 degrees
                            child: SizedBox(
                              height: 27,
                              width: 27,
                              child: Image.asset("images/left-arrow (1).png", fit: BoxFit.contain),
                            ),
                          ),

                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(data.length, (index) {
                        final question = data[index];
                        final choices = question['choices'] as List<Map<String, dynamic>>;
                        final counts = choices.map((c) => c['count'] as int).toList();
                        final labels = choices.map((c) => c['choice_id'] as String).toList();

                        final totalVotes = counts.reduce((a, b) => a + b);
                        final majorityIndex = counts.indexOf(counts.reduce((a, b) => a > b ? a : b));
                        final majorityAnswer = labels[majorityIndex];

                        return Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              // Total Students and Majority Answer
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: screenHeight * 0.14,
                                    width: screenWidth * 0.43,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC8E5FF),
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5,),
                                        Text(
                                          "Total students",
                                          style: TextStyle(fontSize: 12, color: Colors.black38),
                                        ),

                                        SizedBox(height: 25,),
                                        Text(
                                          "$totalVotes",
                                          style: TextStyle(fontSize: 18, fontFamily: "MontserratSemi", color: Color(0xff21334E)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.04,),
                                  Container(
                                    height: screenHeight * 0.14,
                                    width: screenWidth * 0.43,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC8E5FF),
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 5,),
                                          Text(
                                            "The answer by the majority",
                                            style: TextStyle(fontSize: 12, color: Colors.black38),
                                          ),

                                          SizedBox(height: 5,),
                                          Text(
                                            majorityAnswer,
                                            style: TextStyle(fontSize: 15, fontFamily: "MontserratSemi", color: Color(0xff21334E)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.05),

                              /*-------------------PIE CHART-------------------------*/
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 180,
                                    child: PieChart(
                                      PieChartData(
                                        sections: List.generate(choices.length, (i) =>
                                            pieSection(counts[i], totalVotes, colorList[i % colorList.length], i)
                                        ),
                                        centerSpaceRadius: 60, // Adjust the space in the center
                                        sectionsSpace: 1,
                                        pieTouchData: PieTouchData(
                                          touchCallback: (FlTouchEvent event, PieTouchResponse? touchResponse) {
                                            if (touchResponse != null && touchResponse.touchedSection != null) {
                                              setState(() {
                                                selectedSection = touchResponse.touchedSection!.touchedSectionIndex;
                                              });
                                            } else {
                                              setState(() {
                                                selectedSection = -1; // Reset selection if no section is touched
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top : 75,
                                    // left: 160,
                                    left: screenWidth / 2 - 48,
                                    child: Text(
                                      selectedSection == -1
                                          ? '100%'
                                          : '${_getSelectedSectionPercentage(selectedSection, counts, totalVotes).toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontFamily: "MontserratSemi",
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff151521),
                                      ),
                                    ),
                                  ),
                                ],
                              ),


                              SizedBox(height: screenHeight * 0.08),

                              // Legend
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal, // Allows horizontal scrolling
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(labels.length, (i) =>
                                      legendItem(labels[i], colorList[i % colorList.length], counts[i])),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),


                  /*-----------------BACK ARROW----------------------*/
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left :8.0, bottom : 10),
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
              );
          }
      ),
    );
  }
}

Widget legendItem(String label, Color color, int count) {
  return Column(
    children: [
      Row(
        children: [
          Container(width: 22, height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4), // Adjust the value as needed
            ),
          ),
          SizedBox(width: 6),
          Text("$label", style: TextStyle(fontSize: 14, color: Colors.grey[600]),),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left : 25.0),
        child: Text("$count", style: TextStyle(fontSize: 14, color: Color(0xff151521))),
      ),
    ],
  );
}
