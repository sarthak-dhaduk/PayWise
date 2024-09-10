import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:paywise/screens/LoginPage.dart';
import 'package:paywise/screens/SignUpPage.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NextScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(
          255, 140, 82, 255), // Background color similar to your image
      body: Stack(
        children: [
          Center(
            child: Lottie.asset(
              'assets/icons/1.json',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Lottie.asset(
                    'assets/icons/2.json',
                    height: 200,
                    width: 200,
                  ),
                ),
                SizedBox(height: 10),
                TextAnimator(
                  'PayWise',
                  incomingEffect: WidgetTransitionEffects(
                      blur: const Offset(2, 2),
                      duration: const Duration(milliseconds: 800)),
                  // atRestEffect: WidgetRestingEffects.wave(),
                  outgoingEffect: WidgetTransitionEffects(
                      blur: const Offset(2, 2),
                      duration: const Duration(milliseconds: 800)),
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NextScreen extends StatefulWidget {
  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  int _current = 0;
  final List<Widget> _pages = [
    buildPage(
      imagePath: 'assets/images/control_money.png',
      title: 'Gain total control of your money',
      subtitle: 'Become your own money manager and make every cent count',
    ),
    buildPage(
      imagePath: 'assets/images/know_money.png',
      title: 'Know where your money goes',
      subtitle: 'Track your transaction easily, with categories and financial report',
    ),
    buildPage(
      imagePath: 'assets/images/planning_ahead.png',
      title: 'Planning ahead',
      subtitle: 'Setup your budget for each category so you are in control',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CarouselSlider(
                items: _pages,
                options: CarouselOptions(
                  height: screenHeight * 0.75, // Adjusted for responsiveness
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04), // Responsive spacing
            AnimatedSmoothIndicator(
              activeIndex: _current,
              count: _pages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: Color.fromARGB(255, 140, 82, 255),
                dotColor: Color.fromRGBO(238, 229, 255, 1),
                dotHeight: screenHeight * 0.025, // Responsive dot size
                dotWidth: screenHeight * 0.025,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            SizedBox(
              width: screenWidth * 0.85,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color.fromARGB(255, 140, 82, 255),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02), // Responsive button padding
                  textStyle: TextStyle(fontSize: screenHeight * 0.03), // Responsive font size
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Color.fromRGBO(238, 229, 255, 1)),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              width: screenWidth * 0.85,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  textStyle: TextStyle(fontSize: screenHeight * 0.03),
                  side: BorderSide(
                      color: Color.fromARGB(255, 140, 82, 255), width: 2),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Color.fromARGB(255, 140, 82, 255)),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }

  static Widget buildPage(
      {required String imagePath,
      required String title,
      required String subtitle}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var screenHeight = MediaQuery.of(context).size.height;
        // var screenWidth = MediaQuery.of(context).size.width;
        
        return SingleChildScrollView( // Added scroll view to avoid overflow
          child: Padding(
            padding: EdgeInsets.all(screenHeight * 0.05), // Responsive padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, height: screenHeight * 0.4), // Responsive image height
                SizedBox(height: screenHeight * 0.06), // Responsive spacing
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenHeight * 0.04, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
