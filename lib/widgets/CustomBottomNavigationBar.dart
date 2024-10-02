import 'package:flutter/material.dart';
import 'package:paywise/screens/BudgetPage.dart';
import 'package:paywise/screens/CategoriesPage.dart';
import 'package:paywise/screens/HomeScreen.dart';
import 'package:paywise/screens/ProfilePage.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int activeIndex;

  CustomBottomNavigationBar({
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(bottom: 0),
        child: Stack(
          children: [
            CustomPaint(
              size: Size(width, (width * 0.25).toDouble()),
              painter: RPSCustomPainter(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.home_rounded,
                              color: activeIndex == 0
                                  ? Color.fromRGBO(127, 61, 255, 1)
                                  : Colors.grey),
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            ),
                          },
                          iconSize: activeIndex != 0 ? 35 : 36,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          },
                          child: Text(
                            'Home',
                            style: TextStyle(
                                color: activeIndex == 0
                                    ? Color.fromRGBO(127, 61, 255, 1)
                                    : Colors.grey,
                                fontSize: activeIndex != 0 ? 12 : 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.category_rounded,
                              color: activeIndex == 1
                                  ? Color.fromRGBO(127, 61, 255, 1)
                                  : Colors.grey),
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => CategoriesPage()),
                            ),
                          },
                          iconSize: activeIndex != 1 ? 35 : 36,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => CategoriesPage()),
                            );
                          },
                          child: Text(
                            'Category',
                            style: TextStyle(
                                color: activeIndex == 1
                                    ? Color.fromRGBO(127, 61, 255, 1)
                                    : Colors.grey,
                                fontSize: activeIndex != 1 ? 12 : 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.pie_chart_rounded,
                              color: activeIndex == 2
                                  ? Color.fromRGBO(127, 61, 255, 1)
                                  : Colors.grey),
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => BudgetPage()),
                            ),
                          },
                          iconSize: activeIndex != 2 ? 35 : 36,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => BudgetPage()),
                            );
                          },
                          child: Text(
                            'Budget',
                            style: TextStyle(
                                color: activeIndex == 2
                                    ? Color.fromRGBO(127, 61, 255, 1)
                                    : Colors.grey,
                                fontSize: activeIndex != 2 ? 12 : 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.person,
                              color: activeIndex == 3
                                  ? Color.fromRGBO(127, 61, 255, 1)
                                  : Colors.grey),
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()),
                            ),
                          },
                          iconSize: activeIndex != 3 ? 35 : 36,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()),
                            );
                          },
                          child: Text(
                            'Profile',
                            style: TextStyle(
                                color: activeIndex == 3
                                    ? Color.fromRGBO(127, 61, 255, 1)
                                    : Colors.grey,
                                fontSize: activeIndex != 0 ? 12 : 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1

    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromRGBO(127, 61, 255, 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.9950000);
    path_0.lineTo(0, size.height * 0.0050000);
    path_0.quadraticBezierTo(size.width * 0.2813812, size.height * 0.0050000,
        size.width * 0.3751750, size.height * 0.0050000);
    path_0.cubicTo(
        size.width * 0.4363125,
        size.height * 0.0016000,
        size.width * 0.4027750,
        size.height * 0.0845500,
        size.width * 0.4063375,
        size.height * 0.2550000);
    path_0.cubicTo(
        size.width * 0.4066750,
        size.height * 0.5107500,
        size.width * 0.4728125,
        size.height * 0.5777500,
        size.width * 0.5001750,
        size.height * 0.5753500);
    path_0.cubicTo(
        size.width * 0.5270500,
        size.height * 0.5715000,
        size.width * 0.5905875,
        size.height * 0.5098500,
        size.width * 0.5945500,
        size.height * 0.2500000);
    path_0.cubicTo(
        size.width * 0.5965500,
        size.height * 0.0845500,
        size.width * 0.5624000,
        size.height * -0.0009000,
        size.width * 0.6251750,
        0);
    path_0.quadraticBezierTo(size.width * 0.7185687, size.height * 0.0012500,
        size.width * 0.9987500, size.height * 0.0050000);
    path_0.lineTo(size.width * 1.0012500, size.height * 0.9950000);

    canvas.drawPath(path_0, paint_stroke_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
