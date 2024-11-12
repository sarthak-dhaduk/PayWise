import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:paywise/Services/BuudgetAndPremiumNotifications.dart';
import 'package:paywise/screens/NotificationPage.dart';
import 'package:paywise/screens/SplashScreen.dart';
import 'firebase_options.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PayWise());
}

class PayWise extends StatefulWidget {
  const PayWise({super.key});

  @override
  State<PayWise> createState() => _PayWiseState();
}

class _PayWiseState extends State<PayWise> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late SharedPreferences _prefs;

  DateTime _lastNotificationTime = DateTime.now();
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _initNotifications();
    _initializeBudgetCheck();
    _initialPremiumBudgetCheck();
    _listenForCategoryUpdates();
    _listenForPlanValidityUpdates();
    _listenForPremiumUserUpdates();
  }

  Future<void> _initializeBudgetCheck() async {
    await _checkAndAddNotification();
  }

  Future<void> _initialPremiumBudgetCheck() async {
    await _checkAndAddPremiumNotifications();
  }

  Future<bool> _checkAndAddNotification() async {
    bool notificationGenerated = false;

    try {
      QuerySnapshot categorySnapshot =
          await _firestore.collection('categories').get();

      for (var categoryDoc in categorySnapshot.docs) {
        double spendAmount = (categoryDoc['spend'] ?? 0).toDouble();
        double balance = (categoryDoc['balance'] ?? 0).toDouble();
        String categoryName = categoryDoc['name'] ?? '';
        String? email = categoryDoc['email'];

        if (spendAmount > balance) {
          QuerySnapshot existingNotifications = await _firestore
              .collection('notifications')
              .where('email', isEqualTo: email)
              .where('category', isEqualTo: categoryName)
              .get();

          if (existingNotifications.docs.isEmpty) {
            await _firestore.collection('notifications').add({
              'title': "Your Category ($categoryName) Budget Exceed",
              'description': "You have exceeded your budget for $categoryName.",
              'timestamp': DateTime.now(),
              'email': email,
              'category': categoryName,
            });

            notificationGenerated = true;
          }
        }
      }
    } catch (e) {
      print("Error fetching category data: $e");
    }

    return notificationGenerated;
  }

  Future<void> _checkAndAddPremiumNotifications() async {
    bool notificationGenerated = false;

    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('authentication').get();

      for (var userDoc in userSnapshot.docs) {
        String planValidity = userDoc['plan_validity'];
        String email = userDoc['email'];

        DateTime? planExpiryDate = _parsePlanValidity(planValidity);
        if (planExpiryDate != null) {
          bool result = await PremiumNotificationController(
            planExpiryDate: planExpiryDate,
            email: email,
          ).checkAndNotifyPlanExpiry();

          if (result) {
            notificationGenerated = true;
          }
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }

    if (notificationGenerated) {
      print("Notification(s) generated for expired plans.");
    }
  }

  DateTime? _parsePlanValidity(String planValidity) {
    try {
      final parts = planValidity.split(' To ');
      if (parts.length == 2) {
        final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        DateTime endDate = dateFormat.parse(parts[1]);
        return endDate;
      }
    } catch (e) {
      print("Error parsing plan_validity: $e");
    }
    return null;
  }

  void _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    String? lastTimestamp = _prefs.getString('last_notification_time');
    if (lastTimestamp != null) {
      _lastNotificationTime = DateTime.parse(lastTimestamp);
    }
    // Initialize the notification listener for the current email.
    _setupNotificationListener(_prefs.getString('email') ?? '');
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _setEmailAndResetListener(String email) async {
    await _prefs.setString('email', email);
    _notificationSubscription?.cancel();
    _setupNotificationListener(email);
  }

  void _setupNotificationListener(String email) {
    _notificationSubscription = _firestore
        .collection('notifications')
        .where('email', isEqualTo: email)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        DateTime docTimestamp = doc['timestamp'].toDate();

        if (docTimestamp.isAfter(_lastNotificationTime)) {
          String title = doc['title'];
          String description = doc['description'];
          String timestamp = docTimestamp.toString();
          String notificationId = doc.id;

          _showNotification(notificationId, title, description, timestamp);

          _prefs.setString('last_notification_time', timestamp);
          _lastNotificationTime = docTimestamp;
        }
      }
    });
  }

  void _listenForCategoryUpdates() {
    _firestore.collection('categories').snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.modified) {
          var categoryDoc = docChange.doc;
          double spendAmount = (categoryDoc['spend'] ?? 0).toDouble();
          double balance = (categoryDoc['balance'] ?? 0).toDouble();
          String categoryName = categoryDoc['name'] ?? '';
          String? email = categoryDoc['email'];

          if (spendAmount > balance) {
            _firestore
                .collection('notifications')
                .where('email', isEqualTo: email)
                .where('category', isEqualTo: categoryName)
                .get()
                .then((querySnapshot) {
              if (querySnapshot.docs.isEmpty) {
                _firestore.collection('notifications').add({
                  'title': "Budget Exceeded",
                  'description':
                      "Your spending in $categoryName has exceeded the allocated budget.",
                  'timestamp': DateTime.now(),
                  'email': email,
                  'category': categoryName,
                });
              }
            });
          }
        }
      }
    });
  }

  void _listenForPlanValidityUpdates() {
    _firestore.collection('authentication').snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.modified) {
          var userDoc = docChange.doc;
          String planValidity = userDoc['plan_validity'];
          String email = userDoc['email'];

          DateTime? planExpiryDate = _parsePlanValidity(planValidity);
          if (planExpiryDate != null) {
            PremiumNotificationController(
              planExpiryDate: planExpiryDate,
              email: email,
            ).checkAndNotifyPlanExpiry();
          }
        }
      }
    });
  }

  void _listenForPremiumUserUpdates() {
    _firestore.collection('authentication').snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.modified) {
          var userDoc = docChange.doc;
          String email = userDoc['email'];

          PremiumNotificationController(
            planExpiryDate: DateTime.now(), // Provide actual plan expiry if needed
            email: email,
          ).checkAndNotifyPremiumUserUpgrade(userDoc);
        }
      }
    });
  }

  Future<void> _showNotification(
      String notificationId, String title, String body, String timestamp) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      notificationId.hashCode,
      title,
      body,
      platformChannelSpecifics,
      payload: timestamp,
    );
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
