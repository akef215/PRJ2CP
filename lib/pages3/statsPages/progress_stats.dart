import 'dart:convert';

import 'package:esi_quiz/pages3/statsPages/progress_point.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class ProgressStats extends StatefulWidget {
  const ProgressStats({super.key});

  @override
  State<ProgressStats> createState() => _ProgressStatsState();
}

class _ProgressStatsState extends State<ProgressStats> {

  String selectedTimePeriod = 'yearly'; // Default time period
  List<FlSpot> dataPoints = []; // Data points for the chart


  Map<String, List<FlSpot>> allChartData = {};


  Future<Map<String, List<FlSpot>>> loadChartDataFromJson() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay

    // Simulated raw JSON (replace this with real API or local asset later)
    const String rawJson = '''{
    "yearly": [
      { "x": 0, "y": 0 },
      { "x": 1, "y": 25 },
      { "x": 2, "y": 50 },
      { "x": 3, "y": 75 },
      { "x": 4, "y": 90 },
      { "x": 5, "y": 75 },
      { "x": 6, "y": 50 },
      { "x": 7, "y": 85 },
      { "x": 8, "y": 25 }
    ],
    "monthly": [
      { "x": 0, "y": 0 },
      { "x": 1, "y": 10 },
      { "x": 2, "y": 30 },
      { "x": 3, "y": 60 },
      { "x": 4, "y": 90 }
    ]
  }''';


    final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(
        json.decode(rawJson)
    );

    return jsonMap.map((key, value) {
      final List<ProgressPoint> points = (value as List)
          .map((item) => ProgressPoint.fromJson(item))
          .toList();
      return MapEntry(key, points.map((e) => e.toFlSpot()).toList());
    });
  }

  //TODO : UNCOMMENT

  // Future<Map<String, List<FlSpot>>> fetchChartDataFromApi() async {
  //   final response = await http.get(Uri.parse('https://'));
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonMap = json.decode(response.body);
  //
  //     return jsonMap.map((key, value) {
  //       final List<FlSpot> points = (value as List).map((item) {
  //         double x = (item['x'] as num).toDouble();
  //         double y = (item['y'] as num).toDouble();
  //         return FlSpot(x, y);
  //       }).toList();
  //
  //       return MapEntry(key, points);
  //     });
  //   } else {
  //     throw Exception('Failed to load chart data');
  //   }
  // }

  // late Future<Map<String, List<FlSpot>>> futureChartData;
  // @override
  // void initState() {
  //   super.initState();
  //   futureChartData = fetchChartDataFromApi();
  // }

  //TODO COMMENT
  @override
  void initState() {
    super.initState();
    loadChartDataFromJson().then((data) {
      setState(() {
        allChartData = data;
        dataPoints = allChartData[selectedTimePeriod] ?? [];
      });
    });
  }


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
          FutureBuilder<Map<String, List<FlSpot>>>(
              future: loadChartDataFromJson(),
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
                dataPoints = snapshot.data![selectedTimePeriod] ?? [];


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
                                    if (value > 0 && value < 5) {
                                      return Text('Week ${value.toInt()}');
                                    } else {
                                      return Container(); // Hide extra labels
                                    }
                                    //  return Text('Week ${value.toInt() + 1}'); // Display Week 1, Week 2,,,,
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
                              ),
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
                        ),
                      ),
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
