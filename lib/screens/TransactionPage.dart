import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paywise/screens/DetailTransactionPage.dart';

import '../widgets/floatingActionButton.dart';

// Transaction model
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

class Transactionpage extends StatefulWidget {
  const Transactionpage({super.key});

  @override
  State<Transactionpage> createState() => _TransactionpageState();
}

class _TransactionpageState extends State<Transactionpage> {
  int selectedFiltersCount = 0;
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);

    // Set the status bar color and icon brightness
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:
          Color.fromARGB(118, 0, 0, 0), // Set the status bar color to black
      statusBarIconBrightness:
          Brightness.light, // Set the icon color to white for visibility
    ));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomDropdownButton(),
                SizedBox(
                  width: 40,
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Show the filter modal when the filter icon is tapped
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => CustomFilterModal(
                            onApplyFilters: (int count) {
                              // Update the selected filter count when apply button is pressed
                              setState(() {
                                selectedFiltersCount = count;
                              });
                            },
                          ),
                          backgroundColor: Colors
                              .transparent, // Ensure transparent background
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(117, 111, 110, 112), // Border color
                            width: 0.5, // Minimum border width
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.filter_list_rounded, size: 24),
                      ),
                    ),
                    selectedFiltersCount != 0
                        ? Positioned(
                            top: -1,
                            right: -1,
                            child: Container(
                              height: 22,
                              width: 22,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(127, 61, 255, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  '$selectedFiltersCount',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
          // Divider(),
          // Container(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //     child: Container(
          //       padding: const EdgeInsets.all(8),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(8),
          //         color: Color.fromRGBO(126, 61, 255, 0.415),
          //       ),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           Text(
          //             'See your financial report',
          //             style: TextStyle(
          //               color: Color.fromRGBO(126, 61, 255, 1),
          //               fontSize: 16,
          //             ),
          //           ),
          //           SizedBox(
          //             width: 40,
          //           ),
          //           Icon(
          //             Icons.arrow_forward_ios_rounded,
          //             size: 24,
          //             color: Color.fromRGBO(126, 61, 255, 1),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final previousTransaction =
                      index > 0 ? transactions[index - 1] : null;

                  // Get formatted date for the current transaction
                  String currentDate = _formatTransactionDate(transaction.date);
                  String? previousDate;

                  // Check if the previous transaction exists, and get its formatted date
                  if (previousTransaction != null) {
                    previousDate =
                        _formatTransactionDate(previousTransaction.date);
                  }

                  // Check if a date header is needed before this transaction
                  bool showDateHeader = currentDate != previousDate;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDateHeader) // Show the date header if the date changes
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
                      // Transaction item
                      _buildTransactionItem(context, transaction),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Helper method to build each transaction item
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

  // Helper function to format the transaction date
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

// Renamed DropdownButton class to CustomDropdownButton

class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton({super.key});

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
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
                  fontSize: 12,
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
                      fontSize: 12,
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
          height: 42,
          width: 120,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 230, 230, 250), // Light purple background color
            border: Border.all(
              color: const Color.fromARGB(117, 111, 110, 112), // Border color (Purple)
              width: 0.5, // Minimum border width
            ),
            borderRadius: BorderRadius.circular(30), // Border radius
          ),
          elevation: 0,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
          iconSize: 30,
          iconEnabledColor: Color.fromRGBO(127, 61, 255, 1),
          iconDisabledColor: Color.fromARGB(255, 255, 255, 255),
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 1,
          maxHeight: 135,
          width: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          offset: const Offset(4, 0),
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

// Custom Filter Modal as a Widget
class CustomFilterModal extends StatefulWidget {
  final Function(int) onApplyFilters;

  const CustomFilterModal({Key? key, required this.onApplyFilters})
      : super(key: key);

  @override
  State<CustomFilterModal> createState() => _CustomFilterModalState();
}

class _CustomFilterModalState extends State<CustomFilterModal> {
  Map<String, bool> selectedFilters = {
    'Income': false,
    'Expense': false,
    'Transfer': false,
    'Highest': false,
    'Lowest': false,
    'Newest': false,
    'Oldest': false,
    'Shopping': false,
    'Food': false,
    'Traveling': false,
    'Salary': false,
  };

  int get selectedFiltersCount {
    return selectedFilters.values.where((isSelected) => isSelected).length;
  }

  void _onFilterChipTapped(String filter) {
    setState(() {
      selectedFilters[filter] = !selectedFilters[filter]!; // Toggle selection
    });
  }

  @override
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Content of the modal
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Reset filter logic
                        setState(() {
                          selectedFilters.updateAll((key, value) => false);
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(126, 61, 255, 0.352),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              color: Color.fromRGBO(127, 61, 255, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildSectionHeader('Filter By'),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    _buildFilterChip('Income'),
                    _buildFilterChip('Expense'),
                    _buildFilterChip('Transfer'),
                  ],
                ),
                SizedBox(height: 40),
                _buildSectionHeader('Category'),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    _buildFilterChip('Shopping'),
                    _buildFilterChip('Food'),
                    _buildFilterChip('Traveling'),
                    _buildFilterChip('Salary'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose Category',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${selectedFiltersCount} Selected',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 100), // Add spacing to avoid button overlap
              ],
            ),
          ),
          // Apply button pinned at the bottom
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromRGBO(127, 61, 255, 1), // Button color
                minimumSize:
                    Size(double.infinity, 48), // Make button full width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                // Apply filter logic here
                widget.onApplyFilters(selectedFiltersCount);
                Navigator.pop(
                    context); // Close the modal after applying filters
              },
              child: Text(
                'Apply',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create section headers
  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Helper method to create Filter Chips
  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilters[label]!;
    return GestureDetector(
      onTap: () => _onFilterChipTapped(label),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromRGBO(127, 61, 255, 1).withOpacity(0.1)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Color.fromRGBO(127, 61, 255, 1), width: 1.5)
              : Border.all(color: Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color:
                  isSelected ? Color.fromRGBO(127, 61, 255, 1) : Colors.black54,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
