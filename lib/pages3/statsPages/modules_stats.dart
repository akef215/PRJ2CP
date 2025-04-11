import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ModulesStats extends StatefulWidget {
  const ModulesStats({super.key});

  @override
  State<ModulesStats> createState() => _ModulesStatsState();
}

class _ModulesStatsState extends State<ModulesStats> {

  Future<List<Map<String, dynamic>>> fetchStatisticsData() async {
    await Future.delayed(Duration(seconds: 0)); // Simulating backend delay

    return [//TODO : PERCENTAGE ABT WHAT
      {'chapter': 'Chapter 1', 'percentage': 30, 'questions': '3/10'},
      {'chapter': 'Chapter 2', 'percentage': 80, 'questions': '8/10'},
      {'chapter': 'Chapter 3', 'percentage': 60, 'questions': '6/10'},
    ];
  }

  final List<Color> barColors = [Color(0xff9ac7c4), Color(0xffbfe1ff), Color(0xff4f8482)];
  late Future<List<Map<String, dynamic>>> futureStats;

  @override
  void initState() {
    super.initState();
    futureStats = fetchStatisticsData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,

      body:Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchStatisticsData(),
            builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0F3D64)),
          strokeWidth: 5.0,);
        } else if (snapshot.hasError) {
        return const Text("Error loading data", style: TextStyle(color: Colors.white));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text("No data available", style: TextStyle(color: Colors.white));
        }

        List<Map<String, dynamic>> statistics = snapshot.data!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05,),
            Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.55,
              padding: const EdgeInsets.only(right: 3 , left : 15, top : 16, bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xff21334E),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Statistics of each module",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: screenHeight * 0.065),
                  SizedBox(
                    height: screenHeight * 0.4,
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(statistics.length, (index) {
                          var stat = statistics[index];
                          return BarChartGroupData(
                            x: index,
                            barsSpace: 16,
                            barRods: [
                              BarChartRodData(
                                toY: stat['percentage'].toDouble(),
                                color: barColors[index],
                                width: 40,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          );
                        }),

                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  "${value.toInt()}%", // Convert value to percentage format
                                  style: TextStyle(
                                    fontFamily: "MontserratSemi",
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60,
                              getTitlesWidget: (value, meta) {
                                var stat = statistics[value.toInt()];
                                return Column(
                                    mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      stat['questions'], // Example: "3/10"
                                      style: TextStyle(
                                        color: Colors.white, // Matching bar color
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2), // Space between lines
                                    Text(
                                      "Questions",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      "Answered",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,

                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.black87,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                "${statistics[groupIndex]['chapter']}\n${statistics[groupIndex]['questions']}",
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                          touchCallback: (event, response) {
                            if (response != null && response.spot != null) {
                              int index = response.spot!.touchedBarGroupIndex;
                              String chapterName = statistics[index]['chapter'];
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => ChaptersPage(chapterName: chapterName)),
                              // );
                            }
                          },

                        ),
                      ),
                    ),
                  ),
                ],
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
            ),
          ],
        );
        }
        ),
      ) ,
    );
  }
}
