import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paywise/screens/AccountDetails.dart';
import 'package:paywise/screens/AddAccountPage.dart';
import 'package:paywise/screens/ProfilePage.dart';
import 'package:paywise/widgets/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<Map<String, dynamic>> userAccounts = [];
  double totalBalance = 0.0; // To store the total balance

  @override
  void initState() {
    super.initState();
    _fetchUserAccounts();
  }

  String _truncateText(String text) {
    List<String> words = text.split(' ');
    if (words.length > 3) {
      return words.sublist(0, 2).join(' ') + '...';
    } else {
      return text;
    }
  }

  Future<void> _fetchUserAccounts() async {
    await CustomLoader.showLoaderForTask(
        context: context,
        task: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? email = prefs.getString('email');

          if (email != null) {
            try {
              final QuerySnapshot snapshot = await FirebaseFirestore.instance
                  .collection('accounts')
                  .where('email', isEqualTo: email)
                  .get();

              double calculatedTotalBalance = 0.0;

              final List<Map<String, dynamic>> fetchedAccounts =
                  snapshot.docs.map((doc) {
                // Parse the balance and add it to the running total
                double accountBalance =
                    double.tryParse(doc['balance'].toString()) ?? 0.0;
                calculatedTotalBalance += accountBalance;

                return {
                  'acImage': doc['account_image'],
                  'text': doc['account_name'],
                  'balance': doc['balance'].toString(),
                  'color': Color.fromRGBO(127, 61, 255, 0.1), // Custom color
                };
              }).toList();

              setState(() {
                userAccounts = fetchedAccounts;
                totalBalance = calculatedTotalBalance; // Set the total balance
              });
            } catch (e) {
              print("Error fetching user accounts: $e");
            }
          }
        });
  }

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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
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
                opacity: 1,
                child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                'Account Balance',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 10),
              // Display the calculated total balance
              Text(
                '₹${totalBalance.toStringAsFixed(2)}', // Displaying balance with 2 decimal places
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 100),
              Expanded(
                child: ListView.builder(
                  itemCount: userAccounts.length,
                  itemBuilder: (context, index) {
                    final item = userAccounts[index];
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
                              : index == userAccounts.length - 1
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
                                color: userAccounts[index]['color'],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    userAccounts[index]['acImage'],
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            // Text for the menu item
                            Text(
                              _truncateText(userAccounts[index]
                                  ['text']), // Use the truncate function here
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),

                            Spacer(),
                            // Balance
                            Text(
                              '₹${userAccounts[index]['balance']}',
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
