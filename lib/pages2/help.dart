import 'package:flutter/material.dart';
import '../widgets/appbar.dart';


class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<FAQItem> faqs = [
    FAQItem(
      question: "Is your quiz progress not being saved or shown correctly?",
      answer: "Ensure you're logged in and check your connection. Progress is auto-saved to our secure servers.",
    ),
    FAQItem(
      question: "You didn't receive results and scores after submitting answers?",
      answer: "Results may take a few moments to process. Try refreshing the page or check your quizzes and surveys history.",
    ),
    FAQItem(
      question: "Do questions take too long to load?",
      answer: "This might be due to your connection. Try to reconnect.",
    ),
    FAQItem(
      question: "Is my data secure?",
      answer: "Yes! All your data is encrypted and protected.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:  Color(0xff21334E),

      /*-----------------APPBAR------------------*/
      appBar: Custom_appBar().buildAppBar(context, "Help", false),

      /*-----------------BODY------------------*/
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.16, right: screenWidth * 0.1, left :screenWidth * 0.1),
              child: Column(
                children: [
                  Text(
                    "Are you facing some",
                    style: TextStyle(
                      color: const Color(0xffB2DBFF),
                      fontFamily: "MontserratSemi",
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "PROBLEMS?",
                    style: TextStyle(
                      color: const Color(0xffB2DBFF),
                      fontFamily: "RammettoOne",
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.1,left: screenWidth * 0.1, top: screenHeight * 0.05, bottom : screenHeight * 0.03),
              child: Column(
                children: [
                  Text(
                    "You have questions on",
                    style: TextStyle(
                      color: Colors.white, // const Color(0xff21334E),
                      fontFamily: "MontserratSemi",
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "some features?",
                    style: TextStyle(
                      color: Colors.white, // const Color(0xff21334E),
                      fontFamily: "MontserratSemi",
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // We build the FAQ Items
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  ...faqs.map((faq) => _FAQItem(//map throught them
                    question: faq.question,
                    answer: faq.answer,
                  )).toList(),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.07),

            // Back Arrow
            Padding(
              padding:  EdgeInsets.only(left: 8.0, bottom: screenHeight * 0.02),
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
          ],
        ),
      ),
    );
  }
}


class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  __FAQItemState createState() => __FAQItemState();
}

class __FAQItemState extends State<_FAQItem> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xffB2DBFF).withOpacity(0.5), width: 1),
      ),
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.question,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff21334E),
                fontFamily: "MontserratSemi",
              ),
            ),
            trailing: RotationTransition(
              turns: Tween(begin: 0.0, end: 0.5).animate(_animation),
              child: const Icon(Icons.expand_more, color: Color(0xff21334E)),
            ),
            onTap: _toggleExpand,
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.answer,
                style: const TextStyle(
                  color: Color(0xff21334E),
                  fontSize: 13,
                  fontFamily: "Montserrat",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}