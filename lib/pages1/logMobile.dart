import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../pages2/homePage.dart';
import 'createAcc2_1.dart';
import 'recover.dart';
import '../../../widgets/appbar.dart';


String bearerToken = '';
class LogMobile extends StatefulWidget {
  const LogMobile({super.key});

  @override
  State<LogMobile> createState() => _LogMobileState();
}

class _LogMobileState extends State<LogMobile> {
  /*------------PASSWORD VARIABLE--------------*/
  bool _obscureText = true; // Initially hide the user password

  /*------------RETRIEVE USER'S INPUT VARIABLES--------------*/
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /*------------VERIFICATION METHODS--------------*/

  bool isValidEmail(String email) {
    // EMAIL VERIFICATION
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    // PASSWORD VERIFICATION
    return password.length >= 4;
  }

  String? _emailError;
  String? _passwordError;

  String loginMessage = "";
  bool _isLoading = false;

  Future<String> login() async {
    setState(() {
      _isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();


    final url = Uri.parse(
      path + '/auth/students/login',
    ); // For Android emulator we use 'http://10.0.2.2:8000/auth/students/login'
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    print("🔧 Attempting to log in with email: $email");

    try {
      final response = await http.post(url, headers: headers, body: body);

      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bearerToken = data['access_token'];
        print("✅ Login successful! User data: $data");
        print("Bearer Token : $bearerToken");

        setState(() {
          loginMessage = "Login successful!";
          _isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (response.statusCode == 401) {
        print("❌ Invalid email or password.");
        setState(() {
          loginMessage = "Invalid email or password.";
          _isLoading = false;
        });
      } else {
        print("⚠️ Unexpected error: ${response.statusCode} - ${response.body}");
        setState(() {
          loginMessage = "Error: ${response.statusCode} - ${response.body}";
          _isLoading = false;
        });
      }
    } catch (e) {
      print("🚨 Network error: $e");
      setState(() {
        loginMessage =
            e.toString().contains('Connection failed')
                ? "Server unreachable. Is the backend running?"
                : "Network error: $e";
        _isLoading = false;
      });
    }
    print("🛑 Login process complete.");
    return loginMessage;
  }

  // Future<String> login() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   String email = emailController.text.trim();
  //   String password = passwordController.text.trim();
  //
  //   final url = Uri.parse(path + '/auth/students/login');
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = jsonEncode({'email': email, 'password': password});
  //
  //   try {
  //     final response = await http.post(url, headers: headers, body: body);
  //     print('🔐 Login response: ${response.statusCode} - ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final token = data['access_token'];
  //       final tokenType = data['token_type'];
  //
  //       // ✅ Use token to fetch profile
  //       final profileResponse = await http.get(
  //         Uri.parse(path + '/students/me/profile'),
  //         headers: {
  //           'Authorization': '$tokenType $token', // "Bearer <token>"
  //           'Content-Type': 'application/json',
  //         },
  //       );
  //
  //       if (profileResponse.statusCode == 200) {
  //         final profileData = jsonDecode(profileResponse.body);
  //         final studentId = profileData['id'];
  //
  //         // ✅ Save token & studentId in shared preferences
  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.setString('authToken', '$tokenType $token');
  //         await prefs.setString('studentId', studentId.toString());
  //
  //         setState(() {
  //           loginMessage = "Login successful!";
  //           _isLoading = false;
  //         });
  //
  //         // ✅ Navigate to home
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => HomePage()),
  //         );
  //       } else {
  //         setState(() {
  //           loginMessage = "Failed to fetch profile.";
  //           _isLoading = false;
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         loginMessage = "Invalid credentials.";
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       loginMessage = "Network error: $e";
  //       _isLoading = false;
  //     });
  //   }
  //
  //   return loginMessage;
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents shift when keyboard appears
      body: SizedBox(
        /*---------------BACKGROUND----------------*/
        height: screenHeight, // Make it full screen
        width: screenWidth,
        child: Stack(
          // Used for overlapping
          clipBehavior:
              Clip.none, // Allows the image to go outside the box if needed

          children: [
            Positioned.fill(
              child: Image.asset(
                'images/background.jpg',
                fit: BoxFit.cover, // Fill the screen while preventing streches
              ),
            ),

            /*---------------FOREGROUND----------------*/
            Align(
              // Makes sure Container is in the center of stack
              alignment: Alignment.center,
              child: SingleChildScrollView(
                // Ensures UI not shrinking when keyboard shows
                physics:
                    NeverScrollableScrollPhysics(), // Prevents user scrolling

                child: Container(
                  /*-------------MAIN BOX-------------*/
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.8, // Prevents shrinking
                    maxWidth: screenWidth * 0.85,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 50.0,
                    vertical: 70.0,
                  ),
                  margin: EdgeInsets.fromLTRB(35.0, 100.0, 35.0, 100.0),
                  decoration: BoxDecoration(
                    color: Color(0xff21334e),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),

            Align(
              /*-------------MAIN PAGE-------------*/
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Wrap content height
                children: [
                  SizedBox(height: 160), // Push text down
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Log into your account',
                      style: TextStyle(
                        fontFamily: "RammettoOne",
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 60.0),

                  Column(
                    /*-------------LOGIN COLUMN-------------*/
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, bottom: 8.0),
                        child: Text(
                          'work email',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Container(
                        /*---------EMAIL BOX----------*/
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.09,

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
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: Colors.black,
                            ), // User input text black
                            decoration: InputDecoration(
                              hintText: "Enter your email",
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 15,
                              ),
                              border:
                                  InputBorder
                                      .none, // Removes the default black line
                              suffixIcon: Icon(
                                Icons.email,
                                color: Colors.grey[400],
                              ), // Set Email icon on the right
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Email Error Triggered ( When clicking on LogIn Button )
                      if (_emailError != null)
                        Padding(
                          // Reserving space for message error
                          padding: EdgeInsets.only(left: 12.0, top: 4.0),
                          child: Text(
                            _emailError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),

                      SizedBox(height: 40.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, bottom: 8.0),
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Container(
                        /*---------PASSWORD BOX----------*/
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.09,

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
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureText, // Toggle visibility
                            style: TextStyle(
                              color: Colors.black,
                            ), // User input text black
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 15,
                              ),
                              border:
                                  InputBorder
                                      .none, // Removes the default black line of TextField
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () {
                                  // When the icon is pressed we update obscureText state
                                  setState(() {
                                    _obscureText =
                                        !_obscureText; // Toggle state
                                  });
                                },
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Password Error Triggered ( When clicking on LogIn Button )
                      if (_passwordError != null)
                        Padding(
                          // Reserving space for message error
                          padding: EdgeInsets.only(left: 12.0, top: 4.0),
                          child: Text(
                            _passwordError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      SizedBox(height: 7.0),

                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Forgot Password? ',
                              style: TextStyle(
                                color: Colors.white,
                                // fontFamily: "Montserrat" ,
                                fontSize: 12.0,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Recover(),
                                  ),
                                );
                              },
                              child: Text(
                                'Click here',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 12.0,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 50.0),

                  Container(
                    /*------------LOGIN BOX------------*/
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.095,
                    //margin: EdgeInsets.symmetric(horizontal : 40.0, vertical : 10.0),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                    ),

                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          // Update UI
                          String email =
                              emailController.text
                                  .trim(); // Retrieves the current text from the _emailController in TextField
                          String password =
                              passwordController.text
                                  .trim(); // Retrieves the current text from the _passwordController in TextField

                          _emailError =
                              isValidEmail(email)
                                  ? null
                                  : "Invalid email format";
                          _passwordError =
                              isValidPassword(password)
                                  ? null
                                  : "Password must be at least 8 characters";

                          // if (_emailError == null && _passwordError == null) { // VALIDATION
                          //   String message = await login();
                          //   //  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                          // }
                        });
                        if (_emailError == null && _passwordError == null) {
                          String message =
                              await login(); // wait for login and get the result message

                          // Show snackbar for successful/error login
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor:
                                  message.contains("successful")
                                      ? Colors.green
                                      : Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
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
                          'Log In',
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

                  /*-----------CREATE ACCOUNT IF USER DO NOT HAVE ONE : WON'T BE USE !!!------*/
                  // SizedBox(height: 12.0,),
                  // Row(/*----------------DONT HAVE AN ACCOUNT?----------------*/
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Text(
                  //       "Don't have an account? " ,
                  //       style: TextStyle(
                  //         color: Colors.white ,
                  //         // fontFamily: "Montserrat" ,
                  //         fontSize: 12.0 ,
                  //       ),
                  //     ),
                  //
                  //     GestureDetector(
                  //       onTap: (){
                  //         Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAcc2()));
                  //       },
                  //       child: Text( //TODO : MAKE IT A TEXT BUTTON
                  //         'Create Account' ,
                  //         style: TextStyle(
                  //           color: Colors.blueAccent,
                  //           fontSize: 12.0 ,
                  //           decoration: TextDecoration.underline ,
                  //           decorationColor: Colors.blueAccent,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
