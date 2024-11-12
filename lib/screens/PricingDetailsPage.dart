import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PricingDetailsPage extends StatefulWidget {
  @override
  _PricingDetailsPageState createState() => _PricingDetailsPageState();
}

class _PricingDetailsPageState extends State<PricingDetailsPage> {
  Razorpay? _razorpay;
  String userName = "User"; // Default placeholder for the name
  String paymentPlan = ""; // To store the selected plan
  int amount = 0; // Amount for the selected plan in paise
  bool isTried = false;
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
// Default to showing yearly plans
  String selectedFilter = 'year'; // Default to showing yearly plans

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _fetchUserNameAndTrialStatus(); 

    _fetchUserName(); // Fetch the user name when the page initializes
     _checkUserTypeAndUpdatePlans();
  }
Future<void> _fetchUserNameAndTrialStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email'); // Retrieve stored email

  if (email != null) {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('authentication')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        userName = querySnapshot.docs.first['name']; // Fetch "name" field
        isTried = querySnapshot.docs.first['is_tried'] ?? false; // Fetch 'is_tried'
        
        // Update the trial plan's isActive based on isTried value
        plans[1]['isActive'] = isTried;
      });
    }
  }
}
Future<void> _checkUserTypeAndUpdatePlans() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email'); // Retrieve stored email

  if (email != null) {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('authentication')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String userType = querySnapshot.docs.first['user_type'] ?? '';
      
      setState(() {
        if (userType == 'premium user') {
          // Set both the trial and premium plans as active
          plans[1]['isActive'] = true; // Trial Plan
          plans[2]['isActive'] = true; // Yearly Plan
          plans[3]['isActive'] = true; // Monthly Plan
        }
      });
    }
  }
}
  Future<void> _fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email'); // Retrieve stored email

    if (email != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('authentication')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userName = querySnapshot.docs.first['name']; // Fetches "name" field
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  Future<void> handleTryOutPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email != null) {
      DateTime startDate = DateTime.now();
      DateTime endDate = startDate.add(Duration(days: 7));
      String validityPeriod =
          "${startDate.toIso8601String().substring(0, 10)} To ${endDate.toIso8601String().substring(0, 10)}";

      final querySnapshot = await FirebaseFirestore.instance
          .collection('authentication')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('authentication')
            .doc(docId)
            .update({
          'plan_validity': validityPeriod,
          'user_type': 'premium user',
          'is_tried': true,
        });
        Fluttertoast.showToast(msg: "Trial activated successfully.");
      }
    }
  }

 void openPaymentPortal() async {
  final prefs = await SharedPreferences.getInstance();
  final storedEmail = prefs.getString('email');

  // Fetch email from Firebase if available
  String userEmail = storedEmail ?? 'user@example.com';
  if (storedEmail != null) {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('authentication')
        .where('email', isEqualTo: storedEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      userEmail = querySnapshot.docs.first['email'];
    }
  }

  var options = {
    'key': 'rzp_test_7EgWttz5T5md7Q',
    'amount': amount, // Amount in paise
    'name': 'PayWise', // Application name
    'description': 'Payment for ${paymentPlan == "monthly" ? "Monthly Plan" : "Yearly Plan"}',
    'image': 'https://your-image-hosting-url.com/icon.png', // Public URL for logo
    'prefill': {
      'email': userEmail, // Email from Firebase
      'contact': '' // Attempt to keep contact empty
    },
    'external': {
      'wallets': ['paytm']
    },
    'method': {
      'card': true,
      'upi': true,
      'wallet': true,
      'netbanking': true,
    },
    'theme': {
      'color': '#7F3DFF' // App theme color
    }
  };

  try {
    _razorpay?.open(options);
  } catch (e) {
    debugPrint(e.toString());
  }
}


  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
        msg: "SUCCESS PAYMENT: ${response.paymentId}", timeInSecForIosWeb: 4);

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email'); // Retrieve stored email

    if (email != null) {
      DateTime now = DateTime.now();
      DateTime validityEndDate;
      String validityPeriod;

      // Calculate end date based on the selected plan
      if (paymentPlan == "monthly") {
        validityEndDate =
            DateTime(now.year, now.month + 1, now.day); // One month from now
        validityPeriod =
            "${now.toIso8601String().substring(0, 10)} To ${validityEndDate.toIso8601String().substring(0, 10)}";
      } else {
        validityEndDate =
            DateTime(now.year + 1, now.month, now.day); // One year from now
        validityPeriod =
            "${now.toIso8601String().substring(0, 10)} To ${validityEndDate.toIso8601String().substring(0, 10)}";
      }

      // Update the payment validity and user type in the authentication collection
      await FirebaseFirestore.instance
          .collection('authentication')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          String docId = querySnapshot.docs.first.id; // Get the document ID
          FirebaseFirestore.instance
              .collection('authentication')
              .doc(docId)
              .update({
            'plan_validity':
                validityPeriod, // Store the formatted validity period
            'user_type': 'premium user' // Update user type to premium
          }).then((_) {
            Fluttertoast.showToast(msg: "Plan validity and user type updated.");
          }).catchError((error) {
            Fluttertoast.showToast(msg: "Error updating user: $error");
          });
        }
      }).catchError((error) {
        Fluttertoast.showToast(msg: "Error fetching user: $error");
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR HERE: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET IS : ${response.walletName}",
        timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Pricing Details',
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD1B3FF), Color(0xFF9F78FF)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Choose Your Plans',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign up in less than 30 seconds. Try out 7 days free trial. Upgrade at anytime.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton(Icons.calendar_today, 'Yearly', 'year'),
                const SizedBox(width: 16),
                _buildFilterButton(Icons.calendar_month, 'Monthly', 'month'),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    if (plans[index]['filter'] == selectedFilter ||
                        plans[index]['filter'] == 'both') {
                      return _buildPricingCard(plans[index]);
                    }
                    return const SizedBox();
                  },
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
          boxShadow: const [
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
              if (plan['isPopular'] ?? false)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9F78FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.star, color: Colors.yellow, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'MOST POPULAR',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    '${plan["duration"]}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                plan['title'],
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(plan['description'],
                  style: const TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 20),
              ...List.generate(plan['features'].length, (i) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Color(0xFF9F78FF), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            plan['features'][i],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    if (i < plan['features'].length - 1)
                      const Divider(color: Colors.grey, thickness: 0.5),
                  ],
                );
              }),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed:plan['title'] == 'Trial'
                          ? handleTryOutPlan
                          : () {
                              setState(() {
                                paymentPlan = plan['duration'] == " / Month"
                                    ? "monthly"
                                    : "yearly";
                                amount = paymentPlan == "monthly" ? 2900 : 30000;
                              });
                              openPaymentPortal();
                            },
                  child: Text(
                    plan['price'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan['isActive']
                        ? Colors.grey
                        : const Color(0xFF9F78FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
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
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            selectedFilter == filter ? const Color(0xFF9F78FF) : Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}