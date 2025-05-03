import 'package:esi_quiz/pages2/help.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages2/EditProfile.dart';
import '../pages1/firstPage.dart'; // is actually profile info
//import '../pages2/ChangePassWord.dart';

import '../widgets/appbar.dart';
//import 'agenda.dart';
import 'package:http/http.dart' as http;
import '../../../pages1/logMobile.dart';
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String studentId = '';
  String studentName = '';
  String studentEmail = '';
  String studentLevel = '';
  String studentGroupId = '';

  /*-------------METHODS TO SELECT PFP--------------*/
  File? _image; // Store the selected image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImage(); // Load saved image when app starts
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the selected image
      });
      _saveImage(pickedFile.path); // Save image path
    }
  }

  // Save image path to shared preferences
  Future<void> _saveImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);
  }

  // Load image from shared preferences
  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  //fetch Student Infromations
  Future<Map<String, dynamic>> fetchStudentInfo() async {
    // print("something again?");
    final response = await http.get(
      Uri.parse(path + '/students/me/profile'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(
        'Response Body--------------------------------------: ${response.body}',
      );

      return {
        'StudentId': data['id'],
        'name': data['name'], // Keep this as it is (already an integer)
        'email': data['email'],
        'level': data['level'],
        'goupe_id': data['groupe_id'],
      };
    } else {
      print("error respose Fetching Student info ${response.statusCode}");
      throw Exception('Failed to load quiz');
    }
  }

  bool doneLoading = false;
  bool doneOnce = false;
  Future<void> instailizingFucntion() async {
    final data = await fetchStudentInfo();
    studentId = data['StudentId'];
    studentName = data['name'];
    studentEmail = data['email'];
    studentLevel = data['level'];
    studentGroupId = data['goupe_id'];
    doneLoading = true;
    if (doneLoading && !doneOnce) {
      setState(() {});
      doneOnce = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    instailizingFucntion();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffFFFDFD),

      /*-----------------APPBAR------------------*/
      appBar: Custom_appBar().buildAppBar(context, "profile", false),
      /*-----------------BODY------------------*/
      body: Column(
        children: [
          Container(
            /*-----------------BLUE CONTAINER--------------------*/
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
            width: double.infinity,
            height: screenHeight * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Color(0xff21334E),
            ),

            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  //CIRCLE AVATAR
                  top: screenHeight * 0.14,
                  left: screenWidth * 0.32,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage:
                    _image != null
                        ? FileImage(
                      _image!,
                    ) // Show the selected image by the user
                        : null, // else, no image yet

                    child:
                    _image == null
                        ? const Text(
                      "IMAGE",
                      style: TextStyle(
                        fontFamily: "MontserratSemi",
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                        : null,
                  ),
                ),

                /*------------IMAGE PICKER----------------*/
                Positioned(
                  bottom: screenHeight * 0.075,
                  right: screenWidth * 0.33,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xff21334E), width: 1),
                        shape: BoxShape.rectangle,
                      ),
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: Image.asset(
                          "images/camera.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenHeight * 0.001,

                  child: SizedBox(
                    height: screenHeight * 0.08,
                    child: Center(
                      child: Text(
                        studentName,
                        style: const TextStyle(
                          fontFamily: "MontserratSemi",
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.07),

          /*------------------PROFILE MENU-----------------*/
          _buildMenuButton("images/people.png", "Profile Information", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ProfileInfo(
                  studentId: studentId,
                  studentName: studentName,
                  studentEmail: studentEmail,
                  studentGroupId: studentGroupId,
                  studentLevel: studentLevel,
                ),
              ),
            );
          }),
          _buildMenuButton("images/help.png", "Help", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpPage()),
            );
          }), //////////////////////// Need to send somthing to the backend ?
          _buildMenuButton("images/log-out.png", "Log out", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FirstPage()),
            );
          }), //////////////////////// Need to send somthing to the backend ?

          Spacer(),

          /*-----------------BACK ARROW----------------------*/
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Go back to previous page
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: 37,
                      width: 37,
                      child: Image.asset(
                        "images/left-arrow (1).png",
                        fit: BoxFit.contain,
                      ),
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
      ),
    );
  }

  Widget _buildMenuButton(String imagePath, String text, VoidCallback onTap) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.09,
        vertical: screenHeight * 0.015,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Color(0xFFDBEEFF),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Color(0xFF0F3D64), width: 5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /*------------IMAGE ASSET AS THE ICON------------*/
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Image.asset(
                  imagePath,
                  height: 32,
                  width: 32,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 20),

              Text(
                text,
                style: const TextStyle(
                  fontFamily: "MontserratSemi",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF21334E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}