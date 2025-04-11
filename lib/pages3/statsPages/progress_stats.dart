import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressStats extends StatefulWidget {
  const ProgressStats({super.key});

  @override
  State<ProgressStats> createState() => _ProgressStatsState();
}

class _ProgressStatsState extends State<ProgressStats> {

  String selectedTimePeriod = 'yearly'; // Default time period
  List<FlSpot> dataPoints = []; // Data points for the chart

  Future<List<FlSpot>> fetchChartData(String timePeriod) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate backend delay
    return timePeriodData[timePeriod] ?? []; // Return corresponding data
  }


  // Sample data for yearly, monthly (4 weeks), etc.
  final Map<String, List<FlSpot>> timePeriodData = {
    'yearly': [ // BASED ON MONTHS
      FlSpot(0, 0),
      FlSpot(1, 25),
      FlSpot(2, 50),
      FlSpot(3, 75),
      FlSpot(4, 100),
      FlSpot(5, 75),
      FlSpot(6, 50),
      FlSpot(7, 25),
      FlSpot(8, 25),
    ],
    'monthly': [ // BASED ON WEEKS
      FlSpot(0, 0),
      FlSpot(1, 10), // Week 1
      FlSpot(2, 30), // Week 2
      FlSpot(3, 60), // Week 3
      FlSpot(4, 90), // Week 4
    ],
    // Add more data for other time periods
  };

  @override
  void initState() {
    super.initState();
    fetchChartData(selectedTimePeriod).then((data) {
      setState(() {
        dataPoints = data;
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
                      dataPoints = timePeriodData[selectedTimePeriod]!; // Update data points
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
              future: fetchChartData(selectedTimePeriod),
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
                dataPoints = snapshot.data!; // Update data points

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
