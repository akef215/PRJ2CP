import 'package:flutter/material.dart';

import '../results.dart';

class QuizStats extends StatefulWidget {
  const QuizStats({super.key});

  @override
  State<QuizStats> createState() => _QuizStatsState();
}

class _QuizStatsState extends State<QuizStats> {
  // Simulate fetching data from backend with a Future
  Future<List<Map<String, dynamic>>> fetchQuizData() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate delay
    return [
      {'date': '23/02/2025', 'quizNumber': '07', 'progress': 0.68, 'color': Color(0xffFFFFFF)},
      {'date': '15/02/2025', 'quizNumber': '06', 'progress': 0.95, 'color': Color(0xffFFFFFF)},
      {'date': '02/02/2025', 'quizNumber': '05', 'progress': 0.40, 'color': Color(0xff0F3D64)},
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchQuizData(), // Call the fetchQuizData method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while data is being fetched
            return Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0F3D64)),
              strokeWidth: 5.0,
            ));
          } else if (snapshot.hasError) {
            // Show error message if something goes wrong
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle the case where no data is available
            return Center(child: Text('No quizzes found'));
          } else {
            // If data is available, show the quiz data
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.05),
                      child: Text(
                        "Your latest quizzes",
                        style: TextStyle(
                          fontFamily: "MontserratSemi",
                          color: Color(0x7f21334E),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
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
                                fontSize: 12,
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
                  ],
                ),
                SizedBox(height: 20),

                // Display quiz cards based on fetched data
                ...snapshot.data!.map((quizData) {
                  return _buildQuizCard(
                    quizData['date'],
                    quizData['quizNumber'],
                    quizData['progress'],
                    quizData['color'],
                  );
                }).toList(),

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
        },
      ),
    );
  }
}

// Helper method to build a quiz card with a progress line
Widget _buildQuizCard(String date, String quizNumber, double progress, Color color) {
  return Container(
    height: 120,
    padding: EdgeInsets.all(15),
    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Light shadow
          offset: Offset(2, 3),
          blurRadius: 6,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xffB2DBFF).withOpacity(0.8),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                date,
                style: TextStyle(
                  fontFamily: "MontserratSemi",
                  fontSize: 14,
                  color: Color(0xff0F3D64),
                ),
              ),
            ),
            Text(
              '$quizNumber',
              style: TextStyle(
                fontFamily: "RammettoOne",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xff21334E),
                shadows: [
                  Shadow(
                    color: Colors.black26, // Shadow color
                    offset: Offset(1, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Your score',
                  style: TextStyle(
                    fontFamily: "RammettoOne",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff21334E),
                    shadows: [
                      Shadow(
                        color: Colors.black26, // Shadow color
                        offset: Offset(1, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 25),
        // Progress Line
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16), // Rounded corners
              child: LinearProgressIndicator(
                value: progress, // Progress value (e.g., 0.68 for 68%)
                backgroundColor: Color(0xffB2DBFF).withOpacity(0.7), // Background color of the progress bar
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff21334E)), // Progress color
                minHeight: 26, // Increased height (thicker progress bar)
              ),
            ),
            // Percentage text inside the progress bar
            Positioned.fill(
              child: Center(
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}%', // Display percentage inside the progress bar
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "MontserratSemi",
                    fontWeight: FontWeight.w500,
                    color: color, // Text color (white on progress bar)
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
