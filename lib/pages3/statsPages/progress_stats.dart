import 'dart:convert';

import 'package:esi_quiz/pages3/statsPages/progress_point.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import '../../widgets/appbar.dart';

class ProgressStats extends StatefulWidget {
  const ProgressStats({super.key});

  @override
  State<ProgressStats> createState() => _ProgressStatsState();
}

class _ProgressStatsState extends State<ProgressStats> {

  String selectedTimePeriod = 'yearly'; // Default time period
  List<FlSpot> dataPoints = []; // Data points for the chart


  Map<String, List<FlSpot>> allChartData = {};

  //
  // Future<Map<String, List<FlSpot>>> loadChartDataFromJson() async {
  //   await Future.delayed(Duration(seconds: 1)); // Simulate delay
  //
  //   // Simulated raw JSON (replace this with real API or local asset later)
  //   const String rawJson = '''{
  //   "yearly": [
  //     { "x": 0, "y": 0 },
  //     { "x": 1, "y": 25 },
  //     { "x": 2, "y": 50 },
  //     { "x": 3, "y": 75 },
  //     { "x": 4, "y": 90 },
  //     { "x": 5, "y": 75 },
  //     { "x": 6, "y": 50 },
  //     { "x": 7, "y": 85 },
  //     { "x": 8, "y": 25 }
  //   ],
  //   "monthly": [
  //     { "x": 0, "y": 0 },
  //     { "x": 1, "y": 10 },
  //     { "x": 2, "y": 30 },
  //     { "x": 3, "y": 60 },
  //     { "x": 4, "y": 90 }
  //   ]
  // }''';
  //   final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(
  //       json.decode(rawJson)
  //   );
  //
  //   return jsonMap.map((key, value) {
  //     final List<ProgressPoint> points = (value as List)
  //         .map((item) => ProgressPoint.fromJson(item))
  //         .toList();
  //     return MapEntry(key, points.map((e) => e.toFlSpot()).toList());
  //   });
  // }

  Future<List<int>> fetchSubmittedQuizIds(String studentId) async {
    final encodedId = Uri.encodeComponent(studentId); // encodes '24/0006' to '24%2F0006'
    final url = Uri.parse(path + '/quizzes/submitted/quizzes/?student_id=$encodedId');

    try {
      final response = await http.get(url);

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final ids = jsonData.map<int>((quiz) => quiz['id'] as int).toList();
        return ids;
      } else {
        throw Exception('Failed to load submitted quiz ids');
      }
    } catch (e) {
      print('❌ Error fetching submitted quizzes: $e');
      throw e;
    }
  }


//   Future<List<FlSpot>> fetchProgressDataForQuiz(int quizId, String timePeriod) async {
//     // Map the selected time period to the correct query parameter
//     String groupByValue = selectedTimePeriod == 'monthly' ? 'month' : 'year';
// //
// // // Fetch the progress data with the correct 'group_by' value
//     final url = Uri.parse(path + '/statistics/stats/chart/$quizId?group_by=$groupByValue');
// //
//     final response = await http.get(url);
//
//     print('Status: ${response.statusCode}');
//     print('Body: ${response.body}');
//
//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//
//       List<String> xList = List<String>.from(decoded['x']);
//       List<num> yList = List<num>.from(decoded['y']);
//
//       List<FlSpot> dataPoints = [];
//
//       for (int i = 0; i < xList.length; i++) {
//         final xStr = xList[i];
//         final yVal = yList[i].toDouble(); // ensure it's a double
//
//         double x;
//         if (xStr.contains('S')) {
//           // "2025-05-S1" → extract "S1" → 1
//           x = double.tryParse(xStr.split('-').last.replaceAll('S', '')) ?? i.toDouble();
//         } else {
//           // "2025-05" → use index as fallback or a month parser if needed
//           x = i.toDouble();
//         }
//
//         dataPoints.add(FlSpot(x, yVal));
//       }
//
//       return dataPoints;
//     } else {
//       throw Exception('Failed to load progress data for quiz $quizId');
//     }
//   }

  Future<List<FlSpot>> fetchProgressDataForQuiz(int quizId, String timePeriod) async {
    // Map the selected time period to the correct query parameter
    String groupByValue = selectedTimePeriod == 'monthly' ? 'month' : 'year';
//
// // Fetch the progress data with the correct 'group_by' value
    final url = Uri.parse(path + '/statistics/stats/chart/$quizId?group_by=$groupByValue');
//
    final response = await http.get(url);

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      List<String> xList = List<String>.from(decoded['x']);
      List<num> yList = List<num>.from(decoded['y']);

      List<FlSpot> dataPoints = [];

      for (int i = 0; i < xList.length; i++) {
        final xStr = xList[i];
        final yVal = yList[i].toDouble(); // ensure it's a double

        double x;
        if (xStr.contains('S')) {
          // "2025-05-S1" → extract "S1" → 1
          x = double.tryParse(xStr.split('-').last.replaceAll('S', '')) ?? i.toDouble();
        } else if (timePeriod == 'yearly') {
          // "2025-05" → extract "05" → 5
          final monthPart = xStr.split('-').last;
          x = double.tryParse(monthPart) ?? i.toDouble();
        } else {
          // Fallback in case of unexpected format
          x = i.toDouble();
        }

        dataPoints.add(FlSpot(x, yVal));
      }

      return dataPoints;
    } else {
      throw Exception('Failed to load progress data for quiz $quizId');
    }
  }

  Future<List<FlSpot>> loadChartData(String studentId, String timePeriod) async {
    try {
      // Fetch the list of quiz IDs
      List<int> submittedQuizIds = await fetchSubmittedQuizIds(studentId);
      print('Fetched submitted quiz IDs: $submittedQuizIds');

      // Fetch progress data for each quiz and combine them
      List<FlSpot> allDataPoints = [];

      for (int quizId in submittedQuizIds) {
        List<FlSpot> quizData = await fetchProgressDataForQuiz(quizId, timePeriod);
        allDataPoints.addAll(quizData);  // Combine all the data points from each quiz
      }

      return allDataPoints;  // Return the combined list of data points

    } catch (e) {
      print('❌ Error loading chart data: $e');
      throw e;
    }
  }


// FAKE DATA TO TEST
  // Future<List<FlSpot>> loadChartData(String studentId, String timePeriod) async {
  //   final random = Random();
  //   final List<FlSpot> fakeData = [];
  //
  //   if (timePeriod == 'monthly') {
  //     // Simulate data for 4 weeks
  //     for (int i = 1; i <= 4; i++) {
  //       fakeData.add(FlSpot(i.toDouble(), random.nextDouble() * 100)); // Random value between 0 and 100
  //     }
  //   } else if (timePeriod == 'yearly') {
  //     // Simulate data for 12 months
  //     for (int i = 1; i <= 12; i++) {
  //       fakeData.add(FlSpot(i.toDouble(), random.nextDouble() * 100)); // Random value between 0 and 100
  //     }
  //   }
  //
  //   // Simulate a short delay to mimic API loading
  //   await Future.delayed(const Duration(milliseconds: 500));
  //
  //   return fakeData;
  // }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      backgroundColor: Colors.white,

      body: Column(
        children: [
          // Time Period Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 14.0, right: 12),
                margin:  const EdgeInsets.only(right: 18.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), // Rounded corners
                  border: Border.all(color: Color(0xff21334E), width: 1), // Black border
                ),
                child: DropdownButton<String>(
                  value: selectedTimePeriod,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTimePeriod = newValue!; // yearly or weekly
                      dataPoints = allChartData[selectedTimePeriod] ?? [];
                    });
                  },
                  dropdownColor: Colors.white,
                  items: <String>['yearly', 'monthly']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                          value,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "MontserratThin",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          SizedBox(height: 30),

          // Progress Chart
          FutureBuilder<List<FlSpot>>(
              future:  loadChartData('24/0006', selectedTimePeriod),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      SizedBox(height: screenHeight * 0.23,),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff21334E)),
                        strokeWidth: 5.0,
                )],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                List<FlSpot> dataPoints = snapshot.data!;


                return Column(
                  children: [
                    Container(
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.9,
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (selectedTimePeriod == 'monthly') {
                                    if (value >= 1 && value <= 4) { // Corrected condition
                                      return Text('Week ${value.toInt()}');
                                    } else {
                                      return Container(); // Hide extra labels
                                    }
                                  }
                                  return Text('${value.toInt()}');
                                },
                                interval: 1,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()}');
                                },
                                reservedSize: 30, // Adjust as needed for label width
                              ),
                              // Add this property to reverse the y-axis
                              axisNameSize: 0, // To prevent extra spacing
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: dataPoints,
                              isCurved: true,
                              color: Color(0xff21334E),
                              barWidth: 3,
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          // Add this property to control the y-axis range
                          minY: 0,
                          maxY: 100, // Assuming your maximum value is 100
                        ),
                      ),
                      // child: LineChart(
                      //   LineChartData(
                      //     gridData: FlGridData(show: true),
                      //     titlesData: FlTitlesData(
                      //       bottomTitles: AxisTitles(
                      //         sideTitles: SideTitles(
                      //           showTitles: true,
                      //           getTitlesWidget: (value, meta) {
                      //             if (selectedTimePeriod == 'monthly') {
                      //               if (value > 0 && value < 5) {
                      //                 return Text('Week ${value.toInt()}');
                      //               } else {
                      //                 return Container(); // Hide extra labels
                      //               }
                      //               //  return Text('Week ${value.toInt() + 1}'); // Display Week 1, Week 2,,,,
                      //             }
                      //             return Text('${value.toInt()}');
                      //           },
                      //           interval: 1,
                      //         ),
                      //       ),
                      //
                      //       leftTitles: AxisTitles(
                      //         sideTitles: SideTitles(
                      //           showTitles: true,
                      //           getTitlesWidget: (value, meta) {
                      //             return Text('${value.toInt()}');
                      //           },
                      //         ),
                      //       ),
                      //       topTitles: AxisTitles(
                      //         sideTitles: SideTitles(showTitles: false),
                      //       ),
                      //       rightTitles: AxisTitles(
                      //         sideTitles: SideTitles(showTitles: false),
                      //       ),
                      //     ),
                      //
                      //     borderData: FlBorderData(show: true),
                      //     lineBarsData: [
                      //       LineChartBarData(
                      //         spots: dataPoints,
                      //         isCurved: true,
                      //         color: Color(0xff21334E),
                      //         barWidth: 3,
                      //         belowBarData: BarAreaData(show: false),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),

                    SizedBox(height: screenHeight * 0.11,),
                    // Back Arrow
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Go back to previous page
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height: 37,
                                width: 37,
                                child: Image.asset("images/left-arrow (1).png", fit: BoxFit.contain),
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
                  ],
                );
              }
            }
          ),
        ],
      ),

    );
  }
}
