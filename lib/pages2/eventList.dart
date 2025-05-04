import 'package:flutter/material.dart';

class EventList extends StatelessWidget {
  final DateTime selectedDay;
  final Map<DateTime, List<String>> events;

  DateTime _stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  const EventList({
    Key? key,
    required this.selectedDay,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dayEvents = events[_stripTime(selectedDay)] ?? [];


    return dayEvents.isEmpty
        ? Center(
      child: Text(
        "No events for this day",
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    )
        : ListView.builder(
      itemCount: dayEvents.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xff0F3D64),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.event, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  dayEvents[index],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
