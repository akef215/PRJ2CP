import 'package:flutter/material.dart';

class Continue extends StatefulWidget {
  const Continue({super.key});

  @override
  State<Continue> createState() => _CreateAccState();
}

class _CreateAccState extends State<Continue> {

  /*------------PASSWORD VARIABLE--------------*/
  bool _obscureText = true; // Initially hide password
  bool _obscureConfirmText = true;

  /*------------RETRIEVE USER'S INPUT VARIABLES--------------*/
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController esiIdController = TextEditingController();

  // Validate email format
  String? _validateEmail(String email) {
    String emailPattern =
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email) ? null : "Invalid email format";
  }

  /*------------VERIFICATION METHODS--------------*/
  // Validate password
  String? _validatePassword(String password) {
    return password.length >= 8 ? null : "Password must be at least 8 characters";
  }

  // Validate confirm password
  String? _validateConfirmPassword(String confirmPassword) {
    return confirmPassword == passwordController.text
        ? null
        : "Passwords do not match";
  }

  // Validate ESI ID
  String? _validateEsiId(String esiId) {
    return esiId.isNotEmpty ? null : "ESI ID is required";
  }

  // Error message variables
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _esiIdError;

  // Form validation
  void _validateForm() {
    setState(() {
      _emailError = _validateEmail(emailController.text);
      _passwordError = _validatePassword(passwordController.text);
      _confirmPasswordError = _validateConfirmPassword(confirmPasswordController.text);
      _esiIdError = _validateEsiId(esiIdController.text);
    });


    if (_emailError == null && _passwordError == null && _confirmPasswordError == null && _esiIdError == null) {
      // Proceed with the API request or other logic
    }
  }

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
        child: Stack(// Used for overlapping
          clipBehavior: Clip.none, // Allows the image to go outside the box if needed

          children: [
            Positioned.fill(
              child: Image.asset(
                'images/background.jpg',
                fit : BoxFit.cover , // Fill the screen while preventing streches
              ),
            ),

            /*---------------FOREGROUND----------------*/

            Align(// Makes sure Container is in the center of stack
              alignment: Alignment.center,
              child: SingleChildScrollView( // Ensures UI not shrinking when keyboard shows
                physics: NeverScrollableScrollPhysics(), // Prevents user scrolling

                child: Container(  /*-------------MAIN BOX-------------*/
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.86, // Prevents shrinking
                    maxWidth: screenWidth * 0.85,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 70.0),
                  margin: EdgeInsets.fromLTRB(35.0, 80.0, 35.0, 80.0),
                  decoration: BoxDecoration(
                    color: Color(0xff21334e),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Wrap content height
                children: [
                  SizedBox(height: 110), // Push text down
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Create a new account' ,
                      style: TextStyle(
                        fontFamily: "RammettoOne" ,
                        fontSize: 16 ,
                        fontWeight: FontWeight.w500 ,
                        color: Colors.white ,
                      ),
                    ),
                  ),

                  SizedBox(height: 45.0,),
                  Column(/*-------------INFORMATION COLUMN-------------*/
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0 , bottom: 8.0),
                        child: Text(
                          'Email' ,
                          style: TextStyle(
                            fontFamily: "Montserrat" ,
                            fontSize: 14 ,
                            fontWeight: FontWeight.w500 ,
                            color: Colors.white ,
                          ),
                        ),
                      ),

                      Container(/*---------EMAIL BOX----------*/
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.08,

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
                            controller: emailController ,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black), // User input text black
                            decoration: InputDecoration(
                              hintText: "Enter your email" ,
                              hintStyle: TextStyle(
                                color: Colors.grey[500] ,
                                fontSize: 15 ,
                              ),
                              border: InputBorder.none, // Removes the default black line
                              suffixIcon: Icon(Icons.email, color: Colors.grey[400],), // Email icon on the right
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0) ,
                            ),
                          ),

                        ),
                      ),

                      if (_emailError != null)
                        Padding(
                          // Reserving space for message error
                          padding: EdgeInsets.only(left: 12.0, top: 3.0),
                          child: Text(
                            _emailError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),

                      SizedBox(height: 50.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0 , bottom: 8.0),
                        child: Text(
                          'Password' ,
                          style: TextStyle(
                            fontFamily: "Montserrat" ,
                            fontSize: 14 ,
                            fontWeight: FontWeight.w500 ,
                            color: Colors.white ,
                          ),
                        ),
                      ),

                      Container(/*---------PASSWORD BOX----------*/
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.08,

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
                            style: TextStyle(color: Colors.black), // User input text black
                            decoration: InputDecoration(
                              hintText: "Enter your password" ,
                              hintStyle: TextStyle(
                                color: Colors.grey[500] ,
                                fontSize: 15 ,
                              ),
                              border: InputBorder.none, // Removes the default black line of TextField
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText; // Toggle state
                                  });
                                },
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0) ,
                            ),
                          ),
                        ),
                      ),

                      if (_passwordError != null)
                        Padding(
                          // Reserving space for message error
                          padding: EdgeInsets.only(left: 12.0, top: 3.0),
                          child: Text(
                            _passwordError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),

                      SizedBox(height: 50.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0 , bottom: 8.0),
                        child: Text(
                          'Confirm Password' ,
                          style: TextStyle(
                            fontFamily: "Montserrat" ,
                            fontSize: 14 ,
                            fontWeight: FontWeight.w500 ,
                            color: Colors.white ,
                          ),
                        ),
                      ),

                      Container(/*---------CONFIRM PASSWORD BOX----------*/
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.08,

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
                            controller: confirmPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureConfirmText, // Toggle visibility
                            style: TextStyle(color: Colors.black), // User input text black
                            decoration: InputDecoration(
                              hintText: "Confirm password" ,
                              hintStyle: TextStyle(
                                color: Colors.grey[500] ,
                                fontSize: 15 ,
                              ),
                              border: InputBorder.none, // Removes the default black line of TextField
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmText ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmText = !_obscureConfirmText; // Toggle state
                                  });
                                },
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0) ,
                            ),
                          ),
                        ),
                      ),

                      if (_confirmPasswordError != null)
                        Padding(
                          // Reserving space for message error
                          padding: EdgeInsets.only(left: 12.0, top: 3.0),
                          child: Text(
                            _confirmPasswordError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  ),


                  SizedBox(height: 35.0,),
                  Container(/*------------CREATE ACCOUNT BOX------------*/
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.095,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.circular(40.0),
                    ),

                    child: ElevatedButton(
                      onPressed: (){
                        _validateForm();
                        //TODO : HOMEPAGE
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffc8e5ff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        padding: EdgeInsets.all(8),
                        elevation: 0.4, // Shadow
                      ),

                      child:Center(
                        child: Text(
                          'Create' ,
                          style: TextStyle(
                            fontFamily: "RammettoOne" ,
                            fontSize: 18 ,
                            fontWeight: FontWeight.w500 ,
                            color: Color(0xff21334e),
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
      ),
    );
  }
}