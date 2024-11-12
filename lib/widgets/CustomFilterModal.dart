import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomFilterModal extends StatefulWidget {
  final Function(Map<String, bool>) onApplyFilters;

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
  };

  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories when the modal initializes
  }

  Future<void> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('email', isEqualTo: email)
        .get();

    setState(() {
      categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
      for (var category in categories) {
        selectedFilters[category] = false;
      }
    });
  }

  void _onFilterChipTapped(String filter) {
    setState(() {
      selectedFilters[filter] = !selectedFilters[filter]!;
    });
  }

  int get selectedFiltersCount {
    return selectedFilters.values.where((isSelected) => isSelected).length;
  }

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
                  children: categories
                      .map((category) => _buildFilterChip(category))
                      .toList(),
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
                SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(127, 61, 255, 1),
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                widget.onApplyFilters(selectedFilters);
                Navigator.pop(context);
              },
              child: Text(
                'Apply',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilters[label] ?? false;
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
              color: isSelected
                  ? Color.fromRGBO(127, 61, 255, 1)
                  : Colors.black54,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
