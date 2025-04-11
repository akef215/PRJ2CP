import 'package:flutter/material.dart';

import '../pages2/agenda.dart';
import '../pages2/profile.dart';

class Custom_appBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Standard AppBar height

  @override
  Widget build(BuildContext context) {
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                } else if (value == 'modules') {
                  Navigator.pushNamed(context, '/modules');
                } else if (value == 'agenda') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Agenda()));
                } else if (value == 'settings') {
                  Navigator.pushNamed(context, '/settings');
                }
              },

              itemBuilder: (context) =>
              [
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
                      Text("Profile",
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w500)
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'modules',
                  height: 60,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          'images/check.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text("Modules",
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w500)),
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
                      Text("Agenda",
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'settings',
                  height: 60,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          'images/setting (1).png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text("Settings",
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /*----------HOME TEXT---------------*/
          const Text(
            "Home",
            style: TextStyle(
              fontFamily: "MontserratSemi",
              color: Color(0xff21334E),
              fontSize: 20,
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
                child: Image.asset(
                  'images/bell1.png',
                  fit: BoxFit.contain,
                ),
              ),
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Color(0xffdff0ff), width: 6),
              ),
              constraints: BoxConstraints.tightFor(width: 250),
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false, // Disable selection
                  child: SizedBox(
                    height: 200, // Limit height to make it scrollable
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          6, // Simulating 10 notifications
                              (index) => _buildNotificationItem("Notification ${index + 1}", "${(index + 1) * 5}m ago"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}

PopupMenuItem<int> _buildNotificationItem(String title, String time) {
  return PopupMenuItem(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontFamily: "MontserratSemi", color : Color(0xff21334E),fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(height: 4),
        Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
        Divider(), // Adds a line between notifications
      ],
    ),
  );
}
