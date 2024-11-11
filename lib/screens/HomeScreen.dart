import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:paywise/screens/NotificationPage.dart';
import 'package:paywise/screens/TransactionPage.dart';
import 'package:paywise/widgets/CircularMenuWidget.dart';
import 'package:paywise/widgets/CustomBottomNavigationBar.dart';
import 'package:paywise/widgets/line_chart_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeIndex = 0;
String? profileImgUrl;

 void initState() {
    super.initState();
    _fetchProfileImage();
   
  }
Future<Map<String, String?>> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('authentication')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return {
          'name': doc['name'],
          'profile_img': doc['profile_img'],
        };
      }
    }
    return {'name': null, 'profile_img': null};
  }

   Future<void> _fetchProfileImage() async {
    try {
      // Get the current user's auth ID
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      // Fetch the profile image URL from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('authentication')
          .doc(userId)
          .get();

      setState(() {
        profileImgUrl = snapshot['profile_img'] as String?;
      });
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);

  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 248, 237, 216),
                          Color.fromARGB(1, 255, 246, 229),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Fetch user data and display the profile image
                                FutureBuilder<Map<String, String?>>(
                                  future: _loadUserData(), // Fetch user data
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasData && snapshot.data != null) {
                                      final userData = snapshot.data!;
                                      String? profileImgUrl = userData['profile_img'];
                                      
                                      return Container(
                                        height: 60,
                                        width: 60,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Color.fromRGBO(127, 61, 255, 1),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: CircleAvatar(
                                              backgroundImage: profileImgUrl != null
                                                  ? NetworkImage(profileImgUrl!) // Use the fetched profile image
                                                  : AssetImage('assets/images/av1.png') as ImageProvider, // Fallback to placeholder
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return CircleAvatar(
                                        backgroundImage: AssetImage('assets/images/av1.png'), // Default avatar
                                      );
                                    }
                                  },
                                ),
                                DropdownButton(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => NotificationPage()),
                                    );
                                  },
                                  child: Container(
                                    child: Icon(
                                      Icons.notifications_sharp,
                                      size: 32,
                                      color: Color.fromRGBO(127, 61, 255, 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: [
                              Text(
                                'Total Balance',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(0, 0, 0, 170),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '₹9400',
                                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              _buildIncomeExpenseCard('Income', '5000', Colors.green),
                              SizedBox(width: 10),
                              _buildIncomeExpenseCard('Expenses', '1200', Colors.red),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            'Spend Frequency',
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: LineChartWidget(),
                          ),
                          SizedBox(height: 20),
                          Expanded(child: FilterBar()),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Transactions',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => Transactionpage()),
                                  );
                                },
                                child: Container(
                                  height: 35,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromRGBO(126, 61, 255, 0.297),
                                    border: Border.all(color: Color.fromRGBO(126, 61, 255, 1)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'See All',
                                      style: TextStyle(color: Color.fromRGBO(126, 61, 255, 1)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 250,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _buildTransactionCard('Shopping', 'Buy some grocery', '- ₹120', '10:00 AM', Icons.shopping_bag),
                                  _buildTransactionCard('Subscription', 'Disney+ Annual', '- ₹80', '03:30 PM', Icons.subscriptions),
                                  _buildTransactionCard('Food', 'Ramen', '- ₹32', '07:30 PM', Icons.restaurant),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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


  Widget _buildIncomeExpenseCard(String title, String amount, Color color) {
    return Expanded(
      child: Container(
        width: 150,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
        ),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(Icons.currency_rupee_sharp, size: 35, color: color),
              ),
              SizedBox(width: 2),
              Column(
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(amount,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(String title, String subtitle, String amount,
      String time, IconData icon) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.orange,
          size: 40,
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(time, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class DropdownButton extends StatefulWidget {
  const DropdownButton({super.key});

  @override
  State<DropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<DropdownButton> {
  final List<String> items = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Expanded(
              child: Text(
                'Months',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 180,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color.fromARGB(0, 252, 252, 252),
          ),
          elevation: 0,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          iconSize: 45,
          iconEnabledColor: Color.fromRGBO(127, 61, 255, 1),
          iconDisabledColor: Color.fromARGB(255, 255, 255, 255),
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 1,
          maxHeight: 135,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}

class FilterBar extends StatefulWidget {
  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  List<bool> isSelected = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(20),
        fillColor: Color.fromRGBO(126, 61, 255, 0.297),
        selectedBorderColor: Color.fromRGBO(127, 61, 255, 1),
        selectedColor: Color.fromRGBO(127, 61, 255, 1),
        color: Colors.black,
        borderColor: Colors.black12,
        constraints: BoxConstraints(
          minHeight: 35.0,
          minWidth: 75.0,
        ),
        isSelected: isSelected,
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < isSelected.length; i++) {
              isSelected[i] = i == index;
            }
          });
        },
        children: <Widget>[
          Text('Today'),
          Text('Week'),
          Text('Month'),
          Text('Year'),
        ],
      ),
    );
  }

}

