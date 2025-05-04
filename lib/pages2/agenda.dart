
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'eventList.dart';

import 'package:http/http.dart' as http;
import '../../../pages1/logMobile.dart';
import 'dart:convert';
import '../widgets/appbar.dart';

import '../pages3/quizPages/QuizzesStructure.dart';

class Agenda extends StatefulWidget {
  const Agenda({Key? key}) : super(key: key);

  @override
  State<Agenda> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<Agenda> {
  // Variables for day selection
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Method to remove time from DateTime
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  //Will contain a list of events
  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();

    /*_events = {
      _normalizeDate(DateTime(2025, 3, 9)): [
        'Training - 2 hrs - 11:30 pm',
        'Dinner - 1 hrs - 12:30 pm',
      ],
      _normalizeDate(DateTime(2025, 3, 12)): ['Meeting - 1 hrs - 10:00 am'],
    };*/
  }

  Future<Map<String, dynamic>> fetchDayQuizzes(DateTime day) async {
    String dateOnly = day.toIso8601String().split('T')[0];
    print(dateOnly);
    final response = await http.get(
      Uri.parse(path + '/quizzes/day?day=' + dateOnly),
      //headers: {'Authorization': 'Bearer $bearerToken'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(
        'Response Body--------------------------------------: ${response.body}',
      );

      if (data is List && data.isEmpty) {
        // If the list is empty, return an empty list of quizzes
        return {'Quizzes': <Quizzesstructure>[]};
      }

      return {
        'Quizzes':
        (data as List).map((q) => Quizzesstructure.fromJson(q)).toList(),
      };
    } else {
      print("Error response");
      throw Exception('Failed to load quiz');
    }
  }

  Future<List<Quizzesstructure>> loadingDayInfo(DateTime day) async {
    List<Quizzesstructure> quizzesOfTheDay = [];
    final data = await fetchDayQuizzes(day);
    setState(() {
      quizzesOfTheDay = data['Quizzes'];
    });
    return quizzesOfTheDay;
  }

  List<Quizzesstructure> Quizzes = [];
  @override
  Widget build(BuildContext context) {
    //fetchDayQuizzes(DateTime.utc(2010, 1, 1));
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: PreferredSize(
        /*---------------AGENDA APPBAR----------------*/
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Color(0xff21334e),
          title: const Text(
            'Agenda',
            style: TextStyle(
              fontFamily: "MontserratSemi",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: Image.asset("images/Frame 1.png"),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),

      body: Stack(
        children: [
          Column(
            children: [
              /*------------------------------CALENDAR---------------------------*/
              Container(
                color: Color(0xff21334e),
                margin: EdgeInsets.only(top: 3.0),

                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2050, 12, 31),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) async {
                    List<Quizzesstructure> quizzes = await loadingDayInfo(
                      selectedDay,
                    );

                    for (int i = 0; i < Quizzes.length; i++) {
                      print("----------QUIZ $i-------------");
                      print('Title: ${Quizzes[i].title}');
                      print('Date: ${Quizzes[i].date}');
                    }

                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      Quizzes = quizzes;
                    });
                  },
                  headerStyle: HeaderStyle(
                    /*---------------HEADER STYLE-----------------*/
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: const TextStyle(
                      // MONTH
                      color: Colors.white,
                      fontFamily: "MontserratSemi",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),

                  calendarStyle: CalendarStyle(
                    /*----------------CALENDAR STYLE----------------*/
                    selectedDecoration: BoxDecoration(
                      color: Colors.transparent, // Transparent background
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white, // White border
                        width: 2,
                      ),
                    ),
                    defaultTextStyle: const TextStyle(color: Colors.white),
                    weekendTextStyle: const TextStyle(color: Colors.white),

                    todayDecoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),

                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.grey),
                    weekendStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              /*---------------DISPLAY SELECTED DATE PILL---------------*/
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff21334e),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                            '${_selectedDay.year}, ${getMonthName(_selectedDay.month)}, ${_selectedDay.day} ',
                            style: const TextStyle(
                              fontFamily: "MontserratSemi",
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: '(${getWeekdayName(_selectedDay.weekday)})',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /*----------------DISPLAY EVENTS FOR SELECTED DAY----------------*/
              // EventList(
              //   selectedDay: _selectedDay,
              //   events: _events.map((date, eventList) =>
              //       MapEntry(_stripTime(date), eventList)), // Strip times from event dates
              // )
              Expanded(
                child:
                Quizzes.isNotEmpty
                //_events[_normalizeDate(_selectedDay)]?.isNotEmpty == true
                    ? ListView.builder(
                  itemCount: Quizzes.length,
                  //_events[_normalizeDate(_selectedDay)]?.length ??
                  itemBuilder: (context, index) {
                    //String event = Quizzes[index].title;

                    // Split event data and extract the date part
                    //final parts = event.split('-');
                    DateTime eventDate =
                        _selectedDay; // Default to selected day

                    return Card(
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            Quizzes[index].title,
                            //Quizzes[index].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "MontserratSemi",
                              fontSize: 16,
                            ),
                          ),
                          //SIDE TEXT AT THE RIGHT
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDay.toIso8601String().split('T')[0].split("-")[2],
                                //Quizzes[index].date,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff21334e),
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'MMM',
                                ).format(eventDate).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff21334e),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Text(
                    "No events for this day",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: "MontserratSemi",
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
}

// Get day name from number
String getWeekdayName(int weekday) {
  switch (weekday) {
    case 1:
      return 'Mon';
    case 2:
      return 'Tue';
    case 3:
      return 'Wed';
    case 4:
      return 'Thu';
    case 5:
      return 'Fri';
    case 6:
      return 'Sat';
    case 7:
      return 'Sun';
    default:
      return '';
  }
}

// Get month name from number (1 = January)
String getMonthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return months[month - 1];
}
