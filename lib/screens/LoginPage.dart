import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paywise/Services/auth_service.dart';
import 'package:paywise/screens/ForgotPasswordPage.dart';
import 'package:paywise/screens/HomeScreen.dart';
import 'package:paywise/screens/SignUpPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final FirebaseAuth _authh = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _authh.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontSize: screenHeight * 0.03),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_rounded, size: screenHeight * 0.03),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: screenHeight * 0.2),
            TextField(
              controller: _email,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(fontSize: screenHeight * 0.022),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextField(
              obscureText: !_isPasswordVisible,
              controller: _password,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(fontSize: screenHeight * 0.022),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: screenHeight * 0.03,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(127, 61, 255, 1),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: screenHeight * 0.025, color: Colors.white),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Color.fromRGBO(127, 61, 255, 1),
                    fontSize: screenHeight * 0.02,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account yet? ",
                    style: TextStyle(
                        fontSize: screenHeight * 0.02, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Color.fromRGBO(127, 61, 255, 1),
                          fontSize: screenHeight * 0.02,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final User? user = await _auth.signInWithGoogle();
      if (user != null) {
        goToHome(context);
      }
    } catch (error) {
      print("Error during Google Sign-In: $error");
    }
  }

  void goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );

  void goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

  Future<void> _login() async {
    final User? user = await _auth.loginUserWithEmailAndPassword(
      _email.text,
      _password.text,
    );

    if (user != null) {
      // log("User Logged In");

      // Save user data to Shared Preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', _email.text);
      await prefs.setString('uid', user.uid);

      goToHome(context);
    }
  }
}
