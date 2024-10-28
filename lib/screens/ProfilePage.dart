import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paywise/Services/auth_service.dart';
import 'package:paywise/screens/AccountPage.dart';
import 'package:paywise/screens/LoginPage.dart';
import 'package:paywise/screens/PricingDetailsPage.dart';
import 'package:paywise/screens/ProfileUpdatePage.dart';
import 'package:paywise/screens/SettingsPage.dart';
import 'package:paywise/widgets/CircularMenuWidget.dart';
import 'package:paywise/widgets/CustomBottomNavigationBar.dart';
import 'package:paywise/widgets/custom_loader.dart';

class ProfilePage extends StatelessWidget {
  final AuthService auth = AuthService();
  int _activeIndex = 3;
  final Color primaryColor = Color.fromRGBO(127, 61, 255, 1);

  final List<Map<String, dynamic>> menuItems = [
    {
      'svgs': 'assets/icons/Wallet.svg',
      'text': 'Account',
      'color': Color.fromRGBO(127, 61, 255, 0.1), // Light purple
      'root': AccountPage(),
    },
    {
      'svgs': 'assets/icons/settings.svg',
      'text': 'Settings',
      'color': Color.fromRGBO(127, 61, 255, 0.1), // Lighter purple
      'root': SettingsPage(),
    },
    {
      'svgs': 'assets/icons/upload.svg',
      'text': 'Upgrade',
      'color': Color.fromRGBO(127, 61, 255, 0.1), // More vibrant purple
      'root': PricingDetailsPage(),
    },
    {
      'svgs': 'assets/icons/logout.svg',
      'text': 'Logout',
      'color': Color.fromRGBO(255, 61, 61, 0.1), // Light red
      'root': LoginPage(),
    }
  ];

  void _logout() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);

    // Set the status bar color and icon/text brightness
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:
          Color.fromARGB(0, 255, 255, 255), // Semi-transparent black
      statusBarIconBrightness: Brightness.dark, // Icon color to white
      statusBarBrightness: Brightness.dark, // Status bar text color to black
      systemNavigationBarColor:
          Colors.transparent, // Transparent navigation bar
      systemNavigationBarIconBrightness:
          Brightness.light, // Navigation icons white
    ));
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 246, 1),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture with purple border
                Container(
                  height: 80,
                  width: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      color: Colors.white,
                      border: Border.all(
                        color: Color.fromRGBO(127, 61, 255, 1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/av1.png'),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Username",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "Sarthak Dhaduk",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                // Username
                GestureDetector(
                  onTap: () {
                    // Navigate to profile update page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ProfileUpdatePage()),
                    );
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ProfileUpdatePage()),
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(0, 62, 62, 62),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.all(5),
                            child: SvgPicture.asset('assets/icons/edit.svg')),
                      ),
                      onPressed: () {
                        // Edit profile action
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          // Menu Items with ListView.builder
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    await CustomLoader.showLoaderForTask(
                        context: context,
                        task: () async {
                          //Code
                          if (menuItems[index]['text'] == 'Logout') {
                            _logout(); // Correctly log out
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      menuItems[index]['root']),
                            );
                          }
                        });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: menuItems[index]['text'] == 'Account'
                          ? BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))
                          : menuItems[index]['text'] == 'Logout'
                              ? BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15))
                              : BorderRadius.circular(0),
                    ),
                    child: Row(
                      children: [
                        // Icon with specific color
                        Container(
                          decoration: BoxDecoration(
                            color: menuItems[index]['color'],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SvgPicture.asset(menuItems[index]['svgs']),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        // Text for the menu item
                        Text(
                          menuItems[index]['text'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
