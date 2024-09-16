import 'package:flutter/material.dart';
import 'package:paywise/screens/AddExpensePage.dart';
import 'package:paywise/screens/AddIncomePage.dart';
import 'package:paywise/screens/BudgetPage.dart';
import 'package:paywise/screens/HomeScreen.dart';
import 'package:paywise/screens/TransferPage.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';

class floatingActionButton extends StatefulWidget {
  const floatingActionButton({super.key});

  @override
  State<floatingActionButton> createState() => _floatingActionButtonState();
}

class _floatingActionButtonState extends State<floatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return SpinCircleBottomBarHolder(
      bottomNavigationBar: SCBottomBarDetails(
          circleColors: [
            const Color.fromARGB(255, 255, 255, 255),
            const Color.fromARGB(0, 255, 153, 0),
            const Color.fromARGB(0, 255, 82, 82)
          ],
          iconTheme: IconThemeData(
              color: Colors.black45, size: 30, opticalSize: 40, weight: 500),
          activeIconTheme:
              IconThemeData(color: Color.fromRGBO(127, 61, 255, 1), size: 35),
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black45, fontSize: 12),
          activeTitleStyle: TextStyle(
              color: Color.fromRGBO(127, 61, 255, 1),
              fontSize: 12,
              fontWeight: FontWeight.bold),
          actionButtonDetails: SCActionButtonDetails(
              color: Color.fromRGBO(127, 61, 255, 1),
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              ),
              elevation: 3),
          elevation: 3.0,
          items: [
            SCBottomBarItem(
                icon: Icons.home_rounded,
                title: "Home",
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }),
            SCBottomBarItem(
                icon: Icons.category_rounded,
                title: "Category",
                onPressed: () {}),
            SCBottomBarItem(
                icon: Icons.pie_chart_rounded,
                title: "Budget",
                onPressed: () {
                 Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => BudgetPage()),
                  );
                }),
            SCBottomBarItem(
                icon: Icons.person, title: "Profile", onPressed: () {}),
          ],
          circleItems: [
            SCItem(
                icon: Icon(
                  Icons.money_off_csred_rounded,
                  size: 50,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AddExpensePage()),
                  );
                }),
            SCItem(
                icon: Icon(
                  Icons.compare_arrows_rounded,
                  size: 50,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => TransferPage()),
                  );
                }),
            SCItem(
                icon: Icon(
                  Icons.attach_money_rounded,
                  size: 50,
                  color: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AddIncomePage()),
                  );
                }),
          ],
          bnbHeight: 80),
      child: Container(),
    );
  }
}
