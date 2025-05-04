import 'dart:convert';

import 'package:esi_quiz/pages2/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../pages2/agenda.dart';
import '../pages2/help.dart';
import '../pages2/profile.dart';
import '../pages3/quizPages/QuizzesStructure.dart';


String path = 'http://192.168.6.146:8000';

Future<Map<String, dynamic>> fetchQuizzes() async {
  try {
    print("Current path: $path");

    final response = await http.get(Uri.parse(path + '/quizzes/available'));
    print("Response status: ${response.statusCode}"); // Check status code

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response Body: ${response.body}');

      if (data is List && data.isEmpty) {
        return {'Quizzes': <Quizzesstructure>[]};
      }

      return {
        'Quizzes':
        (data as List).map((q) => Quizzesstructure.fromJson(q)).toList(),
      };
    } else {
      print("Error: Received status code ${response.statusCode}");
      throw Exception('Failed to load quiz');
    }
  } catch (e) {
    print("Error occurred while fetching quizzes: $e");
    rethrow; // Rethrow the error so it can be handled by the calling code
  }
}

Future<Map<String, dynamic>> fetchSurveys() async {
  print("something again?");
  final response = await http.get(Uri.parse(path + '/quizzes/surveys'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print(
      'Response Body--------------------------------------: ${response.body}',
    );

    if (data is List && data.isEmpty) {
      // If the list is empty, return an empty list of quizzes
      return {'Surveys': <Quizzesstructure>[]};
    }

    return {
      'Surveys':
      (data as List).map((q) => Quizzesstructure.fromJson(q)).toList(),
    };
  } else {
    print("Error response");
    throw Exception('Failed to load quiz');
  }
}

Future<List<Map<String, dynamic>>> fetchNotifications() async {
  try {
    // Fetch quizzes and surveys concurrently using Future.wait
    final quizzesFuture = fetchQuizzes();
    final surveysFuture = fetchSurveys();

    // Wait for both quizzes and surveys
    final results = await Future.wait([quizzesFuture, surveysFuture]);

    // Extract quizzes and surveys from results
    final quizzes = results[0]['Quizzes'] ?? [];
    final surveys = results[1]['Surveys'] ?? [];

    // Log available quizzes and surveys for debugging purposes
    print('Available Quizzes: $quizzes');
    print('Available Surveys: $surveys');

    // Combine quizzes and surveys into a single list of notifications
    List<Map<String, dynamic>> notifications = [];

    // Add quizzes as notifications if available
    for (var quiz in quizzes) {
      notifications.add({
        'title': quiz.title, // Access title of Quizzesstructure
        'date': quiz.date, // Access date of Quizzesstructure
        'type': 'quiz', // Set type as 'quiz'
      });
    }

    // Add surveys as notifications if available
    for (var survey in surveys) {
      notifications.add({
        'title':
        survey
            .title, // Access title of Quizzesstructure (assuming surveys have similar structure)
        'date': survey.date, // Access date of Quizzesstructure
        'type': 'survey', // Set type as 'survey'
      });
    }

    // Return the notifications (which may be empty if neither is available)
    return notifications;
  } catch (e) {
    print('Error fetching notifications: $e');
    return []; // Return an empty list in case of an error
  }
}

class Custom_appBar extends StatelessWidget implements PreferredSizeWidget {
  // building appBar Function
  AppBar buildAppBar(
      BuildContext context,
      String pageName,
      bool LightBackground,
      ) {
    return AppBar(
      backgroundColor: Colors.transparent,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                } else if (value == 'Home') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else if (value == 'agenda') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Agenda()),
                  );
                } else if (value == 'Help') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpPage()),
                  );
                }
              },

              itemBuilder:
                  (context) => [
                PopupMenuItem(
                  value: 'Home',
                  height: 60,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          'images/home.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Home Page",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff21334E),
                          fontFamily: "MontserratSemi",
                        ),
                      ),
                    ],
                  ),
                ),
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
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff21334E),
                          fontFamily: "MontserratSemi",
                        ),
                      ),
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
                      Text(
                        "Agenda",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff21334E),
                          fontFamily: "MontserratSemi",
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Help',
                  height: 60,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          'images/question.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Help Page",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff21334E),
                          fontFamily: "MontserratSemi",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /*----------HOME TEXT---------------*/
          Text(
            pageName,
            style: TextStyle(
              fontFamily: "MontserratSemi",
              color: LightBackground ? Color(0xff21334E) : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          /*---------NOTIFICATIONS BELL---------*/
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: PopupMenuButton<int>(
              icon: SizedBox(
                width: 37,
                height: 37,
                child: Image.asset('images/bell1.png', fit: BoxFit.contain),
              ),
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Color(0xffdff0ff), width: 6),
              ),
              constraints: BoxConstraints.tightFor(width: 250),
              itemBuilder:
                  (context) => [
                PopupMenuItem(
                  enabled: false, // Disable selection
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future:
                    fetchNotifications(), // Fetch notifications dynamically
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Failed to load notifications'),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Center(child: Text('No new notifications'));
                      } else {
                        return SizedBox(
                          height: 200, // Limit height to make it scrollable
                          child: SingleChildScrollView(
                            child: Column(
                              // children: List.generate(
                              //   snapshot.data!.length,
                              //       (index) => _buildNotificationItem(
                              //     snapshot.data![index]['title'],
                              //     snapshot.data![index]['date'], // Show date
                              //   ),
                              // ),
                              children: List.generate(
                                snapshot.data!.length,
                                    (index) => _buildNotificationItem(
                                  snapshot.data![index]['title'],
                                  snapshot
                                      .data![index]['date'], // Show date instead of timestamp
                                  snapshot
                                      .data![index]['type'], // Add type to be displayed
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Standard AppBar height

  //// the actual build function
  @override
  Widget build(BuildContext context) {
    return buildAppBar(context, "name", true);
  }
}

PopupMenuItem<int> _buildNotificationItem(
    String title,
    String time,
    String type,
    ) {
  return PopupMenuItem(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: "MontserratSemi",
            color: Color(0xff21334E),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
        SizedBox(height: 4),
        Text(
          'A new $type !', // Displaying the type (quizz/survey)
          style: TextStyle(
            color: Colors.blueAccent[100],
            fontSize: 12,
          ), // Adjust style as needed
        ),
        Divider(), // Adds a line between notifications
      ],
    ),
  );
}

// PopupMenuItem<int> _buildNotificationItem(String title, String time) {
//   return PopupMenuItem(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontFamily: "MontserratSemi",
//             color: Color(0xff21334E),
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
//         Divider(), // Adds a line between notifications
//       ],
//     ),
//   );
// }