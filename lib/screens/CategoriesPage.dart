import 'package:flutter/material.dart';
import 'package:paywise/screens/AddCategoryPage.dart';
import 'package:paywise/screens/HomeScreen.dart';
import 'package:paywise/widgets/CircularMenuWidget.dart';
import 'package:paywise/widgets/CustomBottomNavigationBar.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _activeIndex = 1;
  final List<Map<String, dynamic>> _categoryItems = [
    {
      "icon": Icons.subscriptions,
      "name": "Subscription",
      "iconColor": Colors.orange,
    },
    {
      "icon": Icons.music_note,
      "name": "Music",
      "iconColor": Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top purple section
          Container(
            height: 200,
            color: Color.fromRGBO(255, 181, 61, 1),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 5.0, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        "Categories",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 40), // Placeholder to balance the row
                    ],
                  ),
                ),

                // White bottom container with rounded top corners
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: _categoryItems.isEmpty
                              ? Center(
                                  child: Text(
                                    'You don’t have any categories.\n    Let’s make one category.',
                                    style: TextStyle(color: Colors.grey, fontSize: 15),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(10.0),
                                  itemCount: _categoryItems.length,
                                  itemBuilder: (context, index) {
                                    final item = _categoryItems[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color
                                                          .fromARGB(122, 62, 62,
                                                          62), // Border color
                                                      width:
                                                          0.5, // Minimum border width
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Center(
                                                      child: Icon(
                                                        item['icon'],
                                                        color:
                                                            item['iconColor'],
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // Add your delete logic here
                                                  },
                                                  child: Icon(
                                                      Icons.delete_rounded,
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "${item['name']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0,
                              right: 15.0,
                              left: 15.0,
                              bottom: 130.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Button action
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => AddCategoryPage()),
                              );
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
                              "Create a Category",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        activeIndex: _activeIndex,
      ),
      floatingActionButton: CircularMenuWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
