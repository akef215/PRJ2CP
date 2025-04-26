import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  final String imagePath;
  final String text;
  final Color defaultTextColor;
  final Color defaultColor;
  final VoidCallback onTap; // For navigation

  const ProjectCard({
    // Project card constructor
    required this.imagePath,
    required this.text,
    required this.defaultTextColor,
    required this.defaultColor,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  late Color currentColor; // late to prevent nullable variables
  late Color currentTextColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.defaultColor;
    currentTextColor = widget.defaultTextColor;
  }

  void _changeColor(bool isTapped) {
    setState(() {
      if (isTapped) {
        currentColor = Color(0xff21334E); // Change color when we tap
        currentTextColor = Color(0xffFFFFFF);
      } else {
        // Default color on release
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              currentColor = widget.defaultColor;
              currentTextColor = widget.defaultTextColor;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTapDown: (_) => _changeColor(true),
      onTapUp: (_) => _changeColor(false),
      onTapCancel: () => _changeColor(false),
      onTap: widget.onTap,

      /*-------------GRIDS---------------*/
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              spreadRadius: 1, // How much it spreads
              offset: Offset(1, 4), // Shadow position (x, y)
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: screenWidth*0.25,
              width: screenWidth*0.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(widget.imagePath, fit: BoxFit.contain),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: currentTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
