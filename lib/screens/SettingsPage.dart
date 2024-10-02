import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> settingsItems = ['About', 'Help'];

  // Maintenance team information
  final List<Map<String, String>> maintenanceTeam = [
    {
      'name': 'Sarthak Dhaduk',
      'email': 'sarthakdhaduk1111@gmail.com',
    },
    {
      'name': 'Jigar Kalariya',
      'email': 'jigar.kalariya28@gmail.com',
    },
    {
      'name': 'Yash Lalani',
      'email': 'yashlalani43@gmail.com',
    },
  ];

  void _onItemTap(String item) {
    if (item == 'About') {
      _showAboutDialog();
    } else if (item == 'Help') {
      _showHelpDialog();
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'About',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              """
About The Project
"PayWise: Expense Tracker" is a modern financial management app designed to help users take control of their personal finances with ease. Developed as a project by Sarthak Dhaduk, Jigar Kalariya and Yash Lalani, this app offers a comprehensive solution for tracking expenses, managing budgets, and monitoring accounts—all from a single platform.

Built using Flutter, the app provides a seamless and intuitive experience across both Android and iOS devices. Whether you're an individual looking to manage your daily expenses or a small business owner seeking an efficient way to monitor cash flow, "PayWise" is your go-to solution.

Why Use PayWise:
Effortless Financial Management: Track your expenses and income with a few clicks.
Customizable Budgets: Set and monitor spending limits for various categories.
Currency Conversion: Stay in control of your finances, even while dealing with multiple currencies.
Premium Features: Upgrade to access unlimited entries per day and get the most out of your expense tracker.

By using "PayWise," you can focus on what's important—building a better financial future and keeping your spending in check. If you're a developer or a student, this project also offers an opportunity to explore the integration of various technologies like Flutter, Firebase, and Razorpay.

Get started by cloning the repository and running the app locally to see how it works!

Usage
"PayWise: Expense Tracker" is an ideal solution for individuals or small businesses looking to efficiently track their income and expenses. It offers a user-friendly interface with features that cater to both casual users and those with more advanced needs.

Personal Finance Management:
- Track daily, weekly, or monthly expenses and income.
- Set budgets for various categories to stay within your financial goals.

Small Business Accounting:
- Manage multiple accounts and monitor cash flow, making it easy to maintain records for income, expenses, and transfers.
- Use filtering options to generate financial insights and track performance by category or time period.

Learning and Development:
- Developers and students can use this project to learn how to integrate APIs, manage state in Flutter, and implement advanced features like payment gateways (Razorpay), Google Authentication, and more.

The codebase is also a great starting point for adding custom features like expense, reporting, or enhanced analytics.

Features
Basic Features:
- User Sign-In and Sign-Up
- Options to sign in or sign up with or without Google Authentication.
- Forgot Password: Secure process to recover access to your account.
- Profile Management: Update and manage user profile details.

Main Features:
- Manage Accounts: Add, update, and delete accounts seamlessly.
- Track Transactions: Record expenses, income, and money transfers with the ability to delete incorrect entries.
- View transaction details with filtering options by time (yearly, monthly, and weekly) and by category.
- Category Management: Add, update, and delete expense categories.
- Budget Management: Set budgets for specific categories, with options to update or delete budget allocations.

Advanced Features:
- Currency Conversion: Convert transactions to any other currency while entering expenses, income, or transfers. (Powered by API integration)
- Premium Upgrade: Upgrade to the premium version to enjoy unlimited entries per day. The basic version restricts the number of daily entries.
              """,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Help',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: maintenanceTeam.length,
            itemBuilder: (context, index) {
              final member = maintenanceTeam[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 3,
                child: ListTile(
                  title: Text(member['name']!),
                  subtitle: Text(member['email']!),
                  trailing: Icon(
                    Icons.mail_outline,
                    color: Color.fromRGBO(127, 61, 255, 1),
                  ),
                  onTap: () {
                    // Implement email functionality or further action
                    print('Contact ${member['name']} at ${member['email']}');
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: settingsItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onItemTap(settingsItems[index]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      settingsItems[index],
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromRGBO(127, 61, 255, 1),
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
