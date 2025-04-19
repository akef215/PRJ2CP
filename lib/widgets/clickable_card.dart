import 'package:flutter/material.dart';

class ClickableCard extends StatefulWidget {
  final String mainText;
  final String? subText;
  final Widget page;

  const ClickableCard({
    required this.mainText,
    required this.page,
    this.subText,
    Key? key,
  }) : super(key: key);

  @override
  _ClickableCardState createState() => _ClickableCardState();
}

class _ClickableCardState extends State<ClickableCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.page),
        );
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPressed ? Color(0xffaff0ff) : Color(0xffEEF7FF),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black38.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 12.9,
              offset: Offset(12, 10),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.mainText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xff21334E),
                  fontFamily: "RammettoOne",
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              if (widget.subText != null)
                Text(
                  widget.subText!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff21334E),
                    fontFamily: "MontserratSemi",
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
