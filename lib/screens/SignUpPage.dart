import 'package:flutter/material.dart';
import 'package:paywise/Services/auth_service.dart';
import 'package:paywise/screens/HomeScreen.dart';
import 'package:paywise/screens/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController(); // Added name controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

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
            ElevatedButton(
              onPressed: () async {
                final user = await _authService.createUserWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                );
                if (user != null) {
                  await _saveToSharedPrefs(user.email ?? "", user.uid);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
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
            ElevatedButton.icon(
              onPressed: () async {
                final user = await _authService.signInWithGoogle();
                if (user != null) {
                  await _saveToSharedPrefs(user.email ?? "", user.uid);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              },
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

  Future<void> _saveToSharedPrefs(String email, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('uid', uid);
  }
}
