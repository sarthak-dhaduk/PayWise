import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paywise/screens/AddExpensePage.dart';
import 'package:paywise/screens/AddIncomePage.dart';
import 'package:paywise/widgets/line_chart_widget.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                      padding: const EdgeInsets.only(top: 38.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
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
                                  backgroundImage:
                                      AssetImage('assets/images/av1.png'),
                                ),
                              ),
                            ),
                          ),
                          DropdownButton(),
                          Container(
                            child: Icon(
                              Icons.notifications_sharp,
                              size: 32,
                              color: Color.fromRGBO(127, 61, 255, 1),
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
                              color: Color.fromRGBO(0, 0, 0, 170)),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '₹9400',
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        _buildIncomeExpenseCard(
                            'Income', '₹5000', Colors.green),
                        SizedBox(
                          width: 10,
                        ),
                        _buildIncomeExpenseCard(
                            'Expenses', '₹1200', Colors.red),
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Spend Frequency',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: LineChartWidget(),
                      ),
                      SizedBox(height: 20),
                      FilterBar(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Container(
                            height: 35,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromRGBO(126, 61, 255, 0.297),
                              border: Border.all(
                                  color: Color.fromRGBO(126, 61, 255, 1)),
                            ),
                            child: Center(
                              child: Text(
                                'See All',
                                style: TextStyle(
                                    color: Color.fromRGBO(126, 61, 255, 1)),
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
                              _buildTransactionCard(
                                  'Shopping',
                                  'Buy some grocery',
                                  '- ₹120',
                                  '10:00 AM',
                                  Icons.shopping_bag),
                              _buildTransactionCard(
                                  'Subscription',
                                  'Disney+ Annual',
                                  '- ₹80',
                                  '03:30 PM',
                                  Icons.subscriptions),
                              _buildTransactionCard('Food', 'Ramen', '- ₹32',
                                  '07:30 PM', Icons.restaurant),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton(),
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
                      style:
                          TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(amount,
                      style:
                          TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
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
    return ToggleButtons(
      borderRadius: BorderRadius.circular(20),
      fillColor: Color.fromRGBO(126, 61, 255, 0.297),
      selectedBorderColor: Color.fromRGBO(127, 61, 255, 1),
      selectedColor: Color.fromRGBO(127, 61, 255, 1),
      color: Colors.black,
      borderColor: Colors.black12,
      constraints: BoxConstraints(
        minHeight: 35.0,
        minWidth: 80.0,
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
    );
  }
}

class floatingActionButton extends StatefulWidget {
  const floatingActionButton({super.key});

  @override
  State<floatingActionButton> createState() => _floatingActionButtonState();
}

class _floatingActionButtonState extends State<floatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return SpinCircleBottomBarHolder(
      bottomNavigationBar: SCBottomBarDetails(
          circleColors: [
            const Color.fromARGB(255, 255, 255, 255),
            const Color.fromARGB(0, 255, 153, 0),
            const Color.fromARGB(0, 255, 82, 82)
          ],
          iconTheme: IconThemeData(
              color: Colors.black45, size: 30, opticalSize: 40, weight: 500),
          activeIconTheme:
              IconThemeData(color: Color.fromRGBO(127, 61, 255, 1), size: 35),
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black45, fontSize: 12),
          activeTitleStyle: TextStyle(
              color: Color.fromRGBO(127, 61, 255, 1),
              fontSize: 12,
              fontWeight: FontWeight.bold),
          actionButtonDetails: SCActionButtonDetails(
              color: Color.fromRGBO(127, 61, 255, 1),
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              ),
              elevation: 3),
          elevation: 3.0,
          items: [
            SCBottomBarItem(
                icon: Icons.home_rounded, title: "Home", onPressed: () {}),
            SCBottomBarItem(
                icon: Icons.compare_arrows_rounded,
                title: "Transaction",
                onPressed: () {}),
            SCBottomBarItem(
                icon: Icons.pie_chart_rounded,
                title: "Budget",
                onPressed: () {}),
            SCBottomBarItem(
                icon: Icons.person, title: "Profile", onPressed: () {}),
          ],
          circleItems: [
            SCItem(
                icon: Icon(
                  Icons.money_off_csred_rounded,
                  size: 50,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AddExpensePage()),
                  );
                }),
            SCItem(
                icon: Icon(
                  Icons.compare_arrows_rounded,
                  size: 50,
                  color: Colors.blue,
                ),
                onPressed: () {}),
            SCItem(
                icon: Icon(
                  Icons.attach_money_rounded,
                  size: 50,
                  color: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AddIncomePage()),
                  );
                }),
          ],
          bnbHeight: 80),
      child: Container(),
    );
  }
}
