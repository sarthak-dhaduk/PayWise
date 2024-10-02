import 'package:flutter/material.dart';

class PricingDetailsPage extends StatefulWidget {
  @override
  _PricingDetailsPageState createState() => _PricingDetailsPageState();
}

class _PricingDetailsPageState extends State<PricingDetailsPage> {
  final List<Map<String, dynamic>> plans = [
    {
      "filter": "both",
      "title": "Starter",
      "version": "Basic",
      "duration": " / Version",
      "description": "All features with some daily limit",
      "price": "Active Plan",
      "features": [
        "Manage Accounts",
        "Currency Conversion",
        "Track Transactions with limited daily entries.",
        "Category Management",
        "Budget Management",
      ],
      "isActive": true,
    },
    {
      "filter": "both",
      "title": "Trial",
      "version": "Free",
      "duration": " / Week",
      "description": "All features with no limits.",
      "price": "Try Out",
      "features": [
        "Manage Accounts",
        "Currency Conversion",
        "Track Transactions With Unlimited Entries.",
        "Category Management",
        "Budget Management",
      ],
      "isActive": false,
    },
    {
      "filter": "year",
      "title": "Professional",
      "version": "₹300",
      "duration": " / Year",
      "description": "Enjoy!! all features an entire year with no limits.",
      "price": "Choose Plan",
      "features": [
        "Manage Accounts",
        "Currency Conversion",
        "Track Transactions With Unlimited Entries.",
        "Category Management",
        "Budget Management",
      ],
      "isActive": false,
      "isPopular": true,
    },
    {
      "filter": "month",
      "title": "Professional",
      "version": "₹29",
      "duration": " / Month",
      "description": "Enjoy!! all features an entire month with no limits.",
      "price": "Choose Plan",
      "features": [
        "Manage Accounts",
        "Currency Conversion",
        "Track Transactions With Unlimited Entries.",
        "Category Management",
        "Budget Management",
      ],
      "isActive": false,
    },
  ];

  String selectedFilter = 'year'; // Default to showing all plans

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the body behind the app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Pricing Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD1B3FF), // Start color (light purple)
              Color(0xFF9F78FF), // End color (darker purple)
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100), // Adjust for spacing from app bar
            Text(
              'Choose Your Plans',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sign up in less than 30 seconds. Try out 7 days free trial. Upgrade at anytime.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 30),
            // Filter bar (e.g., Find Duration)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton(Icons.calendar_today, 'Yearly', 'year'),
                SizedBox(width: 16),
                _buildFilterButton(Icons.calendar_month, 'Monthly', 'month'),
              ],
            ),
            SizedBox(height: 20),
            // Pricing Plans
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.464),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: plans.length,
                      itemBuilder: (context, index) {
                        if (plans[index]['filter'] == selectedFilter ||
                            plans[index]['filter'] == 'both') {
                          return _buildPricingCard(plans[index]);
                        }
                        return SizedBox(); // Hide plans that don't match the filter
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard(Map<String, dynamic> plan) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plan['isPopular'] != null && plan['isPopular'])
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF9F78FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'MOST POPULAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${plan["version"]}',
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Text(
                    '${plan["duration"]}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                plan['title'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                plan['description'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(plan['features'].length * 2 - 1, (i) {
                  if (i.isEven) {
                    return Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Color(0xFF9F78FF), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            plan['features'][i ~/ 2],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                    );
                  }
                }),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    plan['price'],
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan['isActive']
                        ? Colors.grey
                        : Color(0xFF9F78FF), // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(IconData icon, String text, String filter) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedFilter == filter
            ? Color(0xFF9F78FF)
            : Colors.grey, // Highlight selected filter
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
    );
  }
}
