import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DetailBudgetPage extends StatelessWidget {
  final Map<String, dynamic> budgetItem;

  DetailBudgetPage({required this.budgetItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Detail Budget'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_rounded, color: Colors.black),
            onPressed: () {
              // Add delete functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Category section with icon and name
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.donut_large_rounded, color: budgetItem['progressColor']), // Category icon
                  SizedBox(width: 8),
                  Text(
                    budgetItem['category'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Remaining amount
            Text(
              'Remaining',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 5),
            Text(
              budgetItem['remaining'],
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Progress bar
            Center(
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width * 0.87,
                lineHeight: 10.0,
                barRadius: Radius.circular(10),
                percent: budgetItem['progress'],
                backgroundColor: Colors.grey[300],
                progressColor: budgetItem['progressColor'],
              ),
            ),
            SizedBox(height: 20),

            // Alert message
            if (budgetItem['alert'])
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      budgetItem['alertMessage'],
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                ),
              ),
            Spacer(),

            // Edit button at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to edit budget page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(127, 61, 255, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 80.0),
                ),
                child: Text(
                  "Edit",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
