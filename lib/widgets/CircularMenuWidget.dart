import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:paywise/screens/AddExpensePage.dart';
import 'package:paywise/screens/AddIncomePage.dart';
import 'package:paywise/screens/TransferPage.dart';

class CircularMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.0),
      child: CircularMenu(
        toggleButtonColor: Color.fromRGBO(127, 61, 255, 1),
        radius: 70,
        alignment: Alignment.bottomCenter,
        items: [
          CircularMenuItem(
            margin: 90,
            icon: Icons.money_off_csred_rounded,
            color: Colors.red,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddExpensePage()),
              );
            },
          ),
          CircularMenuItem(
            margin: 90,
            icon: Icons.compare_arrows_rounded,
            color: Colors.blue,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TransferPage()),
              );
            },
          ),
          CircularMenuItem(
            margin: 90,
            icon: Icons.attach_money_rounded,
            color: Colors.green,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddIncomePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
