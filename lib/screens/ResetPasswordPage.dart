import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paywise/screens/ForgotPasswordPage.dart';
import 'package:paywise/screens/HomeScreen.dart';
import 'package:paywise/widgets/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  ResetPasswordPage({required this.email});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _resetPassword() async {
    String newPassword = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    
    await CustomLoader.showLoaderForTask(
        context: context,
        task: () async {
          if (newPassword.isNotEmpty &&
              confirmPassword.isNotEmpty &&
              newPassword == confirmPassword) {
            // Update password in authentication collection
            QuerySnapshot snapshot = await _firestore
                .collection('authentication')
                .where('email', isEqualTo: widget.email)
                .get();

            if (snapshot.docs.isNotEmpty) {
              String authId = snapshot.docs.first.id;

              await _firestore
                  .collection('authentication')
                  .doc(authId)
                  .update({'password': newPassword});

              // Fetch updated user details and cast to Map<String, dynamic>
              final userData =
                  snapshot.docs.first.data() as Map<String, dynamic>;

              // Ensure userData is not null before accessing its fields
              if (userData != null) {
                // Store updated details in SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', userData['email'] ?? '');
                await prefs.setString('auth_id', authId);

                // Redirect to login page or show success message
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              } else {
                // Handle case where user data is null
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error fetching user details')),
                );
              }
            } else {
              // Show error if something goes wrong
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error updating password')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Inappropriate password or password is not matched!')),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height and width
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Reset Password"),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
            );
          },
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          top: screenHeight * 0.05,
          bottom: padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Reset Your Password.",
              style: TextStyle(
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "Enter your new password to complete the recovery process.",
              style: TextStyle(
                fontSize: screenHeight * 0.02,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: "Retype new password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(127, 61, 255, 1),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "Continue",
                style: TextStyle(
                    fontSize: screenHeight * 0.022, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
