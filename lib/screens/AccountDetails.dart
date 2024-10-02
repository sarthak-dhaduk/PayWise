import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:paywise/screens/DetailTransactionPage.dart';
import 'package:paywise/widgets/CircularMenuWidget.dart';
import 'package:paywise/widgets/CustomBottomNavigationBar.dart';

class Transaction {
  final String title;
  final String description;
  final String amount;
  final String time;
  final bool isIncome;
  final IconData icon;
  final DateTime date; // New field to store transaction date

  Transaction({
    required this.title,
    required this.description,
    required this.amount,
    required this.time,
    required this.isIncome,
    required this.icon,
    required this.date, // Transaction date
  });
}

class AccountDetails extends StatelessWidget {
  int _activeIndex = 3;
  final Map<String, dynamic> menuItem;

  AccountDetails({required this.menuItem});

  final List<Transaction> transactions = [
    Transaction(
      title: 'Shopping',
      description: 'Buy some grocery',
      amount: '- ₹120',
      time: '10:00 AM',
      isIncome: false,
      icon: Icons.shopping_bag,
      date: DateTime.now(), // Today
    ),
    Transaction(
      title: 'Subscription',
      description: 'Disney+ Annual',
      amount: '- ₹80',
      time: '03:30 PM',
      isIncome: false,
      icon: Icons.subscriptions,
      date: DateTime.now(), // Today
    ),
    Transaction(
      title: 'Food',
      description: 'Buy a ramen',
      amount: '- ₹32',
      time: '07:30 PM',
      isIncome: false,
      icon: Icons.restaurant,
      date: DateTime.now(), // Today
    ),
    Transaction(
      title: 'Salary',
      description: 'Salary for July',
      amount: '+ ₹5000',
      time: '04:30 PM',
      isIncome: true,
      icon: Icons.attach_money,
      date: DateTime.now().subtract(Duration(days: 1)), // Yesterday
    ),
    Transaction(
      title: 'Transportation',
      description: 'Charging Tesla',
      amount: '- ₹18',
      time: '08:30 PM',
      isIncome: false,
      icon: Icons.directions_car,
      date: DateTime.now().subtract(Duration(days: 1)), // Yesterday
    ),
    Transaction(
      title: 'Concert',
      description: 'Music Festival',
      amount: '- ₹250',
      time: '09:30 PM',
      isIncome: false,
      icon: Icons.music_note,
      date: DateTime(2024, 10, 17), // Specific date
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Detail account'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 62, 62, 62),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.all(13),
              child: SvgPicture.asset('assets/icons/edit.svg')),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Container(
                  height: 200,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: menuItem['color'],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(
                              menuItem['acImage'],
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        menuItem['text'],
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '₹${menuItem['balance']}',
                        style: TextStyle(
                            color: Color.fromRGBO(33, 35, 37, 1),
                            fontSize: 32,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ), // Adjust the height for your top section
                ),
              ),
              ListView.builder(
                shrinkWrap:
                    true, // Make ListView take up only the space it needs
                physics:
                    const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final previousTransaction =
                      index > 0 ? transactions[index - 1] : null;

                  String currentDate = _formatTransactionDate(transaction.date);
                  String? previousDate;

                  if (previousTransaction != null) {
                    previousDate =
                        _formatTransactionDate(previousTransaction.date);
                  }

                  bool showDateHeader = currentDate != previousDate;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDateHeader)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            currentDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      _buildTransactionItem(context, transaction),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        activeIndex: _activeIndex,
      ),
      floatingActionButton: CircularMenuWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to the detail transaction page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailTransactionPage(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0.5,
                blurRadius: 0.5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: transaction.isIncome
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
              ),
              child: Icon(
                transaction.icon,
                color: transaction.isIncome ? Colors.green : Colors.red,
                size: 30,
              ),
            ),
            title: Text(
              transaction.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(transaction.description),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.amount,
                  style: TextStyle(
                    color: transaction.isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final today =
        DateTime(now.year, now.month, now.day); // Today's date without time
    final yesterday = DateTime(
        now.year, now.month, now.day - 1); // Yesterday's date without time
    final transactionDate = DateTime(
        date.year, date.month, date.day); // Transaction date without time

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      // Format the date as '17 Oct 2024'
      return DateFormat('d MMM y').format(date);
    }
  }
}
