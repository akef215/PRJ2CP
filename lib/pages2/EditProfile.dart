
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/appbar.dart';



class ProfileInfo extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String studentLevel;
  final String studentGroupId;
  const ProfileInfo({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.studentLevel,
    required this.studentGroupId,
  });

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffFFFDFD),

      /*-----------------APPBAR------------------*/
      appBar: Custom_appBar().buildAppBar(
        context,
        "Profile information",
        false,
      ),

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
                        widget.studentName,
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

          SizedBox(height: screenHeight * 0.05),

          /*----------------------------------------Profile info------------------------------------*/
          Container(
            height: screenHeight*0.4,
            child: SingleChildScrollView(

              child: Column(
                children: [
                  // title
                  SizedBox(
                    height: screenHeight * 0.065,
                    child: Text(
                      "Profile Information",
                      style: const TextStyle(
                        fontFamily: "MontserratSemi",
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF21334E),
                      ),
                    ),
                  ),
                  _buildInfoBar("Student ID:", widget.studentId),
                  _buildInfoBar("Student Name:", widget.studentName),
                  _buildInfoBar("Student Email:", widget.studentEmail),
                  _buildInfoBar("Student Level:", widget.studentLevel),
                  _buildInfoBar("Student Group ID:", widget.studentGroupId),
                ],
              ),
            ),
          ),


          /*-----------------BACK ARROW----------------------*/
          Spacer(),
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

  /// Creating Boxes to fill in
  Widget _buildInfoBar(String title, String info) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.09,
        vertical: screenHeight * 0.0015,
      ),
      child: Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: "MontserratSemi",
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 125, 136, 152),
                ),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Text(
                info,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: "MontserratSemi",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF21334E),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.013),
          ],
        ),
      ),
    );
  }

  Widget _buildFillInBoxes(
      double boxWidth,
      double boxHieght,
      String enteredText,
      ) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.09,
        vertical: screenHeight * 0.015,
      ),
      child: Container(
        width: boxWidth,
        height: boxHieght,
        padding: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Color(0xffc8e5ff),
          borderRadius: BorderRadius.circular(25.0),
        ),

        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),

          child: TextField(
            style: TextStyle(color: Colors.black), // User input text black
            decoration: InputDecoration(
              hintText: enteredText,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
              border: InputBorder.none, // Removes the default black line
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, VoidCallback onTap) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.2,
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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: "MontserratSemi",
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF21334E),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

PopupMenuItem<int> _buildNotificationItem(String title, String time) {
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
        Divider(), // Adds a line between notifications
      ],
    ),
  );
}
