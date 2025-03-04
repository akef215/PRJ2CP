import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'logMobile.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(

        /*---------------BACKGROUND----------------*/
        height: screenHeight, // Full screen
        width: screenWidth,
        child: Stack( // Used for overlapping elements
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/background.jpg',
                fit: BoxFit.cover, // Prevents streches
              ),
            ),

            /*---------------FOREGROUND----------------*/
            Container( /*-------------MAIN BOX-------------*/
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 70.0),
              margin: const EdgeInsets.fromLTRB(35.0, 100.0, 35.0, 100.0),
              decoration: BoxDecoration(
                color: const Color(0xff21334e),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Column( /*-------------IMAGE + TEXT-------------*/
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 160),
                  Image.asset( /*------------IMAGE------------*/
                    'images/persons.png',
                    height: 250.0,
                    width: 250.0,
                  ),
                  const SizedBox(height: 20.0),

                  const Padding(/*------------TEXT1------------*/
                    padding: EdgeInsets.only(right: 100.0),
                    child: Text(
                      'Learn today',
                      style: TextStyle(
                        fontFamily: "RammettoOne",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10.0),

                  const Padding(/*------------TEXT2------------*/
                    padding: EdgeInsets.only(left: 80.0),
                    child: Text(
                      'Lead tomorrow',
                      style: TextStyle(
                        fontFamily: "RammettoOne",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60.0),

                  /*------------GET STARTED BOX------------*/
                  Container(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.095,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                    ),

                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LogMobile()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffc8e5ff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        padding: EdgeInsets.all(8),
                        elevation: 0.4, // Shadow
                      ),
                      child: Center(
                        child: Text(
                          'Get started',
                          style: TextStyle(
                            fontFamily: "RammettoOne",
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff21334e),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
