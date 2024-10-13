import 'package:flutter/material.dart';
import 'package:paywise/Services/auth_service.dart';
import 'package:paywise/screens/HomeScreen.dart';
import 'package:paywise/screens/LoginPage.dart';
import 'package:paywise/widgets/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController(); // Name controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final _auth = AuthService();

  @override
  void dispose() {
    _nameController.dispose(); // Dispose of the name controller
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isPasswordVisible = false;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(fontSize: screenHeight * 0.025),
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
          children: <Widget>[
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Join Us!",
              style: TextStyle(
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "Create your account and start managing your finances effortlessly.",
              style: TextStyle(
                fontSize: screenHeight * 0.02,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Name TextField
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(fontSize: screenHeight * 0.022),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Email TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(fontSize: screenHeight * 0.022),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
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
            // Terms and Conditions Checkbox
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(3),
                  height: screenHeight * 0.04,
                  width: screenHeight * 0.04,
                  child: Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                      splashRadius: 40,
                      activeColor: Color.fromRGBO(127, 61, 255, 1),
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'By signing up, ',
                      style: TextStyle(
                          fontSize: screenHeight * 0.02, color: Colors.black),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'you agree to the',
                        ),
                        TextSpan(
                          text: ' Terms of Service and Privacy Policy',
                          style: TextStyle(
                            color: Color.fromRGBO(127, 61, 255, 1),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            // Sign-Up Button
            ElevatedButton(
              onPressed: () async {
                // Use the custom loader for dynamic tasks
                await CustomLoader.showLoaderForTask(
                  context: context,
                  task: () async {
                    if (_nameController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty &&
                        _isChecked) {
                      try {
                        final user =
                            await _authService.createUserWithEmailAndPassword(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                        );

                        if (user != null) {
                          await _saveToSharedPrefs(
                              user['email']!, user['auth_id']!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        } else {
                          _showSnackbar(
                              context, 'Sign-up failed. Please try again.');
                        }
                      } catch (e) {
                        _showSnackbar(context, 'Error: ${e.toString()}');
                      }
                    } else {
                      _showSnackbar(context,
                          'Please fill in all fields and agree to the terms.');
                    }
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(127, 61, 255, 1),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: screenHeight * 0.025, color: Colors.white),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Or with",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.grey, fontSize: screenHeight * 0.02),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Sign-Up With Google Button
            ElevatedButton.icon(
              onPressed: _handleGoogleSignIn,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              icon: Image.asset(
                'assets/images/google_logo.png',
                height: screenHeight * 0.04,
              ),
              label: Text(
                "Sign Up With Google",
                style: TextStyle(
                    fontSize: screenHeight * 0.025, color: Colors.black),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Redirect to Login Page
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account?',
                    style: TextStyle(
                        fontSize: screenHeight * 0.02, color: Colors.black),
                    children: const <TextSpan>[
                      TextSpan(
                        text: ' Login',
                        style: TextStyle(
                            color: Color.fromRGBO(127, 61, 255, 1),
                            fontSize: 16),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    await CustomLoader.showLoaderForTask(
        context: context,
        task: () async {
          try {
            // Call the Google sign-in method, which returns a Map<String, String>?
            final result = await _auth.signInWithGoogle();

            // Check if result is not null and contains the required user info (like uid)
            if (result != null && result.containsKey('uid')) {
              // Optionally store the email or other user information in SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('uid', result['uid']!);

              // Navigate to the HomeScreen
            } else {
              print('Google sign-in failed');
            }
          } catch (error) {
            print("Error during Google Sign-In: $error");
          }
        });
  }

  Future<void> _saveToSharedPrefs(String email, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('uid', uid);
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
