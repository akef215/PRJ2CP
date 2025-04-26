import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages2/EditProfile.dart';
import '../pages1/firstPage.dart';
import '../pages2/ChangePassWord.dart';

import '../widgets/appbar.dart';
//import 'agenda.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                    height: screenHeight * 0.1,
                    child: Center(
                      child: Text(
                        "Uername",
                        style: const TextStyle(
                          fontFamily: "MontserratSemi",
                          fontSize: 20,
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

          /*------------------PROFILE MENU-----------------*/
          _buildMenuButton("images/pen.png", "Edit profile", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfile()),
            );
          }),
          _buildMenuButton("images/padlock.png", "Change Password ", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePassword()),
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
                  height: 34,
                  width: 34,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 20),

              Text(
                text,
                style: const TextStyle(
                  fontFamily: "MontserratSemi",
                  fontSize: 21,
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