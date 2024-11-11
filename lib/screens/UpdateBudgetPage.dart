import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // To get the current month

class Updatebudgetpage extends StatefulWidget {
   final String categoryName;

 
  const Updatebudgetpage({super.key, required this.categoryName});

  @override
  State<Updatebudgetpage> createState() => _UpdatebudgetpageState();
}

class _UpdatebudgetpageState extends State<Updatebudgetpage>
    with SingleTickerProviderStateMixin {
  String? selectedCategory;
  List<String> categories = [];
  bool alert = true;
  double _currentSliderValue = 70;
  TextEditingController amountController = TextEditingController();

  // New variables for additional Firestore fields
  double? amount;
  bool isAlertEnabled = false;
  double alertPercentage = 0.0;

  double topContainerHeight = 420;
  double bottomContainerHeight = 380;
  double maxHeight = 650;
  double minHeight = 200;
  late AnimationController _controller;
  late Animation<double> _animation;

 

  Future<void> fetchInitialBudgetData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    // Fetch initial budget data from Firestore
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('email', isEqualTo: email)
        .where('name', isEqualTo: widget.categoryName)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final initialBudget = snapshot.docs.first.data();

      setState(() {
        // Set initial selected category
        selectedCategory = initialBudget['name'];
        amount = initialBudget['balance']*1.0 ?? 0;
        amountController.text = amount.toString();

        // Set alert fields
        isAlertEnabled = initialBudget['is_alert'] ?? false;
        alertPercentage = initialBudget['alert_percentage'] ?? 0.0;

        // Update UI components
        alert = isAlertEnabled;
        _currentSliderValue = alertPercentage;
      });
    }
  }
 @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchInitialBudgetData(); // Fetch initial budget data

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Faster response time
    );
    _animation =
        Tween<double>(begin: bottomContainerHeight, end: bottomContainerHeight)
            .animate(_controller);
  }
  void onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      bottomContainerHeight -=
          details.delta.dy * 1.7; // Increase scroll sensitivity
      if (bottomContainerHeight > maxHeight) bottomContainerHeight = maxHeight;
      if (bottomContainerHeight < minHeight) bottomContainerHeight = minHeight;
    });
  }

  void onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final spring = SpringDescription(
      mass: 1,
      stiffness: 2000,
      damping: 7,
    );

    final simulation = SpringSimulation(
        spring, bottomContainerHeight, bottomContainerHeight, velocity / 1000);

    _controller.animateWith(simulation);
  }

  Future<void> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    // Fetch categories where the user's email matches
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('email', isEqualTo: email)
        .get();

    setState(() {
      // Populate the dropdown list with category names
      categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

// Fetches the balance for the selected category and updates the amountController
  Future<void> fetchCategoryBalance(String categoryName) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    // Query Firestore to get the category matching the selected name and email
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('email', isEqualTo: email)
        .where('name', isEqualTo: categoryName)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final categoryData = snapshot.docs.first.data();
      setState(() {
        // Set the amountController to the balance of the selected category
        amount = categoryData['balance'] ?? 0;
        amountController.text = amount.toString();

        // Set alert-related values
        isAlertEnabled = categoryData['is_alert'] ?? false;
        alertPercentage = categoryData['alert_percentage'] ?? 0.0;

        // Update the switch and slider values
        alert = isAlertEnabled;
        _currentSliderValue =
            alertPercentage; // Update slider based on Firestore value
      });
    } else {
      // Handle the case where no matching document was found
      print(
          "No matching category found for the selected email and category name.");
    }
  }

  Future<void> saveBudget() async {
    if (selectedCategory != null && amountController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';
      final currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
      final amount = double.tryParse(amountController.text) ?? 0;

      final budgetData = {
        'email': email,
        'name': selectedCategory,
        'balance': amount,
        'current_month': currentMonth,
        'is_alert': alert,
        'is_reached': false,
        'spend': 0,
        'alert_msg': "You’ve exceeded the limit!",
        'alert_percentage': alert ? _currentSliderValue : null,
      };

      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('categories')
            .where('email', isEqualTo: email)
            .where('name', isEqualTo: selectedCategory)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final docId = snapshot.docs.first.id;

          await FirebaseFirestore.instance
              .collection('categories')
              .doc(docId)
              .update(budgetData);

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Budget updated successfully!')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Category not found')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill in all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(127, 61, 255, 1),
        centerTitle: true,
        title: Text('Update Budget', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            child: Container(
              color: Color.fromRGBO(127, 61, 255, 1),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Text(
                    'How much do you want to spend?',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.64),
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    controller: amountController,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.currency_rupee_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: onVerticalDragUpdate,
              onVerticalDragEnd: onVerticalDragEnd,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: bottomContainerHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          DropdownButtonFormField2<String>(
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    filled: true,
    fillColor: Colors.grey[200], // Optional: greyed out to indicate read-only
  ),
  items: categories.map((String item) {
    return DropdownMenuItem<String>(
      value: item,
      child: Text(item),
    );
  }).toList(),
  value: selectedCategory,
  onChanged: null, // This makes the dropdown read-only
  hint: Text('Select Category'),
),

                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Receive Alert',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Receive alert when it reaches some point.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: alert,
                                activeColor: Color.fromRGBO(127, 61, 255, 1),
                                onChanged: (bool value) {
                                  setState(() {
                                    alert = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (alert) ...[
                            Slider(
                              value: _currentSliderValue,
                              max: 100,
                              divisions: 10,
                              activeColor: Color.fromRGBO(127, 61, 255, 1),
                              label: "${_currentSliderValue.round()}%",
                              onChanged: (double value) {
                                setState(() {
                                  _currentSliderValue = value;
                                });
                              },
                            ),
                          ],
                          SizedBox(height: 16),
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: saveBudget,
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(127, 61, 255, 1),
                                minimumSize: Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
