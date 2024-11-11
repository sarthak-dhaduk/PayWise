// premium_notification_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PremiumNotificationController {
  final DateTime planExpiryDate;
  final String email;

  PremiumNotificationController({
    required this.planExpiryDate,
    required this.email,
  });

  Future<bool> checkAndNotifyPlanExpiry() async {
    String title;
    String description;

    try {
      DateTime now = DateTime.now();
      DateTime oneWeekBeforeExpiry = planExpiryDate.subtract(Duration(days: 7));

      if (now.isAfter(planExpiryDate)) {
        title = "Your plan has expired";
        description = "Your plan expired on ${planExpiryDate.toLocal().toString()}. Please renew it.";
        await _addNotification(title, description);
        return true;
      }

      if (now.isAfter(oneWeekBeforeExpiry) && now.isBefore(planExpiryDate)) {
        title = "Your plan is about to expire";
        description = "Your plan will expire in 7 days. Renew soon.";
        await _addNotification(title, description);
        return true;
      }
    } catch (e) {
      print("Error in checkAndNotifyPlanExpiry: $e");
    }

    return false;
  }

  Future<void> checkAndNotifyPremiumUserUpgrade(DocumentSnapshot userDoc) async {
    try {
      if (userDoc['user_type'] == 'premium user') {
        String title = "Welcome to Premium!";
        String description = "Congratulations on upgrading to Premium. Enjoy the exclusive features!";

        QuerySnapshot existingNotifications = await FirebaseFirestore.instance
            .collection('notifications')
            .where('title', isEqualTo: title)
            .where('email', isEqualTo: email)
            .get();

        if (existingNotifications.docs.isEmpty) {
          await _addNotification(title, description);
          print("Notification added for Premium User upgrade");
        } else {
          print("Premium User upgrade notification already exists for $email. Skipping.");
        }
      }
    } catch (e) {
      print("Error in checkAndNotifyPremiumUserUpgrade: $e");
    }
  }

  Future<void> _addNotification(String title, String description) async {
    try {
      QuerySnapshot existingNotifications = await FirebaseFirestore.instance
          .collection('notifications')
          .where('title', isEqualTo: title)
          .where('email', isEqualTo: email)
          .get();

      if (existingNotifications.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('notifications').add({
          'title': title,
          'description': description,
          'timestamp': FieldValue.serverTimestamp(),
          'email': email,
        });
        print("Notification added for $title");
      } else {
        print("Notification already exists for $email. Skipping.");
      }
    } catch (e) {
      print("Error adding notification: $e");
    }
  }
}
