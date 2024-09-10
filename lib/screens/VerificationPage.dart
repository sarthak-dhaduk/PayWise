import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:paywise/screens/ForgotPasswordPage.dart';
import 'package:paywise/screens/ResetPasswordPage.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final int _pinLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  int _remainingTime = 119;
  late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_pinLength, (_) => TextEditingController());
    _focusNodes = List.generate(_pinLength, (_) => FocusNode());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _remainingTime = 0;
        });
        _timer.cancel();
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _remainingTime = 119; // Reset to the initial timer value
    });
    _timer.cancel();
    _startTimer();
  }

  String get _formattedTime {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _onKeyPressed(String value) {
    if (value == 'backspace') {
      if (_currentIndex > 0) {
        setState(() {
          _controllers[_currentIndex].clear();
          _currentIndex--;
          FocusScope.of(context).requestFocus(_focusNodes[_currentIndex]);
          _controllers[_currentIndex].clear();
        });
      } else if (_currentIndex == 0) {
        setState(() {
          _controllers[_currentIndex].clear();
        });
      }
    } else if (_currentIndex < _pinLength) {
      setState(() {
        _controllers[_currentIndex].text = value;
        if (_currentIndex < _pinLength - 1) {
          _currentIndex++;
        }
        FocusScope.of(context).requestFocus(_focusNodes[_currentIndex]);
      });
    }
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Verification",
          style: TextStyle(fontSize: screenHeight * 0.025),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
            );
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: screenHeight * 0.03,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.03),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter your Verification Code",
                      style: TextStyle(
                        fontSize: screenHeight * 0.025,
                        color: Color.fromRGBO(0, 0, 0, 80),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      _pinLength,
                      (index) => _buildPinBox(index, screenHeight, screenWidth),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  if (_remainingTime > 0)
                    Text(
                      _formattedTime,
                      style: TextStyle(
                        fontSize: screenHeight * 0.025,
                        color: Color.fromRGBO(127, 61, 255, 1),
                      ),
                      textAlign: TextAlign.left,
                    )
                  else
                    TextButton(
                      onPressed: () {
                        _resetTimer(); // Reset the timer when the button is clicked
                      },
                      child: Text(
                        "Send code again",
                        style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: Color.fromRGBO(127, 61, 255, 1),
                        ),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.01),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "We sent a verification code to your email",
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        color: Colors.black54,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: '\nsdhad*****@gmail.com',
                          style: TextStyle(
                            color: Color.fromRGBO(127, 61, 255, 1),
                            fontSize: 17,
                          ),
                        ),
                        TextSpan(
                          text: '. You can check your inbox.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(127, 61, 255, 1),
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Verify",
                      style: TextStyle(
                          fontSize: screenHeight * 0.025, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildCustomKeyboard(screenHeight, screenWidth), // Positioned at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildPinBox(int index, double screenHeight, double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.12,
      height: screenHeight * 0.06,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        readOnly: true,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: screenHeight * 0.03,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(127, 61, 255, 1), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomKeyboard(double screenHeight, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('1', screenHeight),
              _buildKeyboardButton('2', screenHeight),
              _buildKeyboardButton('3', screenHeight),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('4', screenHeight),
              _buildKeyboardButton('5', screenHeight),
              _buildKeyboardButton('6', screenHeight),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('7', screenHeight),
              _buildKeyboardButton('8', screenHeight),
              _buildKeyboardButton('9', screenHeight),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('0', screenHeight),
              SizedBox(width: screenWidth * 0.15),
              _buildKeyboardButton('backspace', screenHeight, isBackspace: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardButton(String value, double screenHeight,
      {bool isBackspace = false}) {
    return GestureDetector(
      onTap: () => _onKeyPressed(value),
      child: Container(
        width: screenHeight * 0.1,
        height: screenHeight * 0.1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: isBackspace
            ? Icon(
                Icons.backspace,
                size: screenHeight * 0.03,
                color: Color.fromRGBO(127, 61, 255, 1),
              )
            : Text(
                value,
                style: TextStyle(
                  fontSize: screenHeight * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(127, 61, 255, 1),
                ),
              ),
      ),
    );
  }
}
