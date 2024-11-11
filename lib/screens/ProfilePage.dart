import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final AuthService auth = AuthService();
  int _activeIndex = 3;
  final Color primaryColor = Color.fromRGBO(127, 61, 255, 1);

Future<Map<String, String?>> _loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  if (email != null) {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('authentication')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        print("Name found: ${doc['name']}"); // Debug print

        // Check if profile_img exists in the document
        final profileImg = doc.data().containsKey('profile_img') && doc['profile_img'] != null
            ? doc['profile_img']
            : 'assets/images/av1.png'; // Use default image

        return {
          'name': doc['name'],
          'profile_img': profileImg,
        };
      } else {
        print("No document found with the given email");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Return default values if no document or error occurs
  return {'name': 'Name not set', 'profile_img': 'assets/images/av1.png'};
}


  final List<Map<String, dynamic>> menuItems = [
    {
      'svgs': 'assets/icons/Wallet.svg',
      'text': 'Account',
      'color': Color.fromRGBO(127, 61, 255, 0.1),
      'root': AccountPage(),
    },
    {
      'svgs': 'assets/icons/settings.svg',
      'text': 'Settings',
      'color': Color.fromRGBO(127, 61, 255, 0.1),
      'root': SettingsPage(),
    },
    {
      'svgs': 'assets/icons/upload.svg',
      'text': 'Upgrade',
      'color': Color.fromRGBO(127, 61, 255, 0.1),
      'root': PricingDetailsPage(),
    },
    {
      'svgs': 'assets/icons/logout.svg',
      'text': 'Logout',
      'color': Color.fromRGBO(255, 61, 61, 0.1),
      'root': LoginPage(),
    }
  ];

  void _logout() async {
    await auth.signout();
  }
@override
Widget build(BuildContext context) {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(0, 255, 255, 255),
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
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
              FutureBuilder<Map<String, String?>>(
                future: _loadUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final userData = snapshot.data!;
                    final profileImg = userData['profile_img'];

                    return Container(
                      height: 80,
                      width: 80,
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
                          backgroundImage: (profileImg != null && profileImg.startsWith('http'))
                              ? NetworkImage(profileImg)
                              : AssetImage('assets/images/av1.png') as ImageProvider,
                          onBackgroundImageError: (exception, stackTrace) {
                            debugPrint('Error loading profile image: $exception');
                          },
                        ),
                      ),
                    );
                  } else {
                    return CircleAvatar(
                      backgroundImage: AssetImage('assets/images/av1.png'),
                    );
                  }
                },
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
                  FutureBuilder<Map<String, String?>>(
                    future: _loadUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          "Loading...",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        );
                      } else if (snapshot.hasData &&
                          snapshot.data!['name'] != null) {
                        return Text(
                          snapshot.data!['name']!,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        );
                      } else {
                        return Text(
                          "Name not found",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ProfileUpdatePage()),
                  );
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: SvgPicture.asset('assets/icons/edit.svg'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ProfileUpdatePage()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  await CustomLoader.showLoaderForTask(
                      context: context,
                      task: () async {
                        if (menuItems[index]['text'] == 'Logout') {
                          _logout();
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
