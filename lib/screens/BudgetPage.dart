import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paywise/screens/AddBudgetPage.dart';
import 'package:paywise/screens/DetailBudgetPage.dart';
import 'package:paywise/screens/HomeScreen.dart';
import 'package:paywise/widgets/CircularMenuWidget.dart';
import 'package:paywise/widgets/CustomBottomNavigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int _activeIndex = 2;
  int _currentMonthIndex = 4;

  final List<String> _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  void initState() {
    super.initState();
  }

  // Fetch the email from SharedPreferences asynchronously
  Future<String> _getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentMonthIndex = (_currentMonthIndex - 1 + _months.length) % _months.length;
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonthIndex = (_currentMonthIndex + 1) % _months.length;
    });
  }

  // Navigate to DetailBudgetPage
  void _goToDetailPage(Map<String, dynamic> budgetItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailBudgetPage(budgetItem: budgetItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 200,
            color: Color.fromRGBO(127, 61, 255, 1),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        "Budget",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        onPressed: _goToPreviousMonth,
                      ),
                      Text(
                        _months[_currentMonthIndex],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                        onPressed: _goToNextMonth,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: FutureBuilder<String>(
                      future: _getUserEmail(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final email = snapshot.data!;
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('categories')
                              .where('email', isEqualTo: email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                             List<Map<String, dynamic>> _budgetItems = snapshot.data!.docs
        .where((doc) {
          // Safely access document data and check if it contains the 'balance' field
          var data = doc.data();
          return data is Map<String, dynamic> && data.containsKey('balance');
        })
        .map((doc) {
                              final balance = doc['balance'] ?? 0.0;
                              final spend = doc['spend'] ?? 0.0;
                              final progress = (balance > 0) ? spend / balance : 0.0;
                              final remaining = (balance - spend).clamp(0.0, double.infinity);
                              bool alert = spend > balance;
                              String alertMessage = alert ? 'You’ve exceeded the limit!': '';

                              return {
                                'category': doc['name'],
                                'remaining': '₹${remaining.toStringAsFixed(2)}',
                                'spent': '₹${spend.toStringAsFixed(2)} of ₹${balance.toStringAsFixed(2)}',
                                'progress': progress.clamp(0.0, 1.0),
                                'progressColor': progress >= 1 ? Colors.red : progress >= 0.5 ? Colors.orange : Colors.green,
                                'alert': alert,
                                'alertMessage': alertMessage,
                              };
                            }).toList();

                            return ListView.builder(
                              padding: const EdgeInsets.all(10.0),
                              itemCount: _budgetItems.length,
                              itemBuilder: (context, index) {
                                final item = _budgetItems[index];
                                return GestureDetector(
                                  onTap: () => _goToDetailPage(item),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color.fromARGB(122, 62, 62, 62),
                                                    width: 0.5,
                                                  ),
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor: item['progressColor'],
                                                        radius: 5,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        item['category'],
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (item['alert'])
                                                Icon(Icons.error_outline, color: Colors.red),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Remaining ${item['remaining']}",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                            child: LinearPercentIndicator(
                                              width: MediaQuery.of(context).size.width - 70,
                                              barRadius: Radius.circular(10),
                                              lineHeight: 10.0,
                                              percent: item['progress'],
                                              backgroundColor: Colors.grey[300],
                                              progressColor: item['progressColor'],
                                            ),
                                          ),
                                          Text(item['spent'], style: TextStyle(color: Colors.grey)),
                                          if (item['alert'])
                                            Text(item['alertMessage'], style: TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0, bottom: 130.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddBudgetPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(127, 61, 255, 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
                    ),
                    child: Text("Create a budget", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(activeIndex: _activeIndex),
      floatingActionButton: CircularMenuWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}