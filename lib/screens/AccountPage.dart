import 'package:flutter/material.dart';
import 'package:paywise/screens/AccountDetails.dart';
import 'package:paywise/screens/AddAccountPage.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final List<Map<String, dynamic>> menuItems = [
    {
      'acImage': 'assets/images/wallet.png',
      'text': 'Wallet',
      'balance': '400',
      'color': Color.fromRGBO(127, 61, 255, 0.1), // Light purple
    },
    {
      'acImage': 'assets/images/gpay.png',
      'text': 'Gpay',
      'balance': '3000',
      'color': Color.fromRGBO(127, 61, 255, 0.1), // Lighter purple
    },
    {
      'acImage': 'assets/images/phonepay.png',
      'text': 'PhonePay',
      'balance': '5000',
      'color': Color.fromRGBO(127, 61, 255, 0.1), // More vibrant purple
    },
    {
      'acImage': 'assets/images/Bank.png',
      'text': 'Paypal',
      'balance': '1000',
      'color': Color.fromRGBO(127, 61, 255, 0.1), // Light red
    }
  ];

  void _goToDetailPage(Map<String, dynamic> menuItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetails(menuItem: menuItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Account',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          FractionallySizedBox(
            widthFactor: 1.0,
            child: Positioned(
              top: 0,
              child: Opacity(
                opacity: 1, // Adjust as per your need
                child: Image.asset(
                  'assets/images/background.png', // Replace with your background image path
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                'Account Balance',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 10),
              Text(
                '₹9400',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return GestureDetector(
                      onTap: () => _goToDetailPage(item),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: index == 0
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))
                              : index == menuItems.length - 1
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))
                                  : BorderRadius.circular(0),
                        ),
                        child: Row(
                          children: [
                            // Icon with specific color
                            Container(
                              decoration: BoxDecoration(
                                color: menuItems[index]['color'],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    menuItems[index]['acImage'],
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            // Text for the menu item
                            Text(
                              menuItems[index]['text'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Spacer(), // Adds spacing between the text and balance, pushing balance to the right
                            // Text for the balance, aligned to the right
                            Text(
                              menuItems[index]['balance'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 20.0, bottom: 50.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(127, 61, 255, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Add your onPressed functionality
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAccountPage(),
                        ),
                      );
                    },
                    child: Text(
                      '+ Add new account',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
