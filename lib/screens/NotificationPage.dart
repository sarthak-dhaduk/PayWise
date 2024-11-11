import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _showDetails = false;
  Map<String, dynamic>? _selectedNotification;
  String? sharedPrefEmail;

  @override
  void initState() {
    super.initState();
    _loadSharedPrefEmail();
  }

  Future<void> _loadSharedPrefEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sharedPrefEmail = prefs.getString('email'); // Load the email from SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Mark all read':
                  _markAllRead();
                  break;
                case 'Remove all':
                  _removeAll();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Mark all read', 'Remove all'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: Icon(Icons.more_horiz_rounded),
            position: PopupMenuPosition.under,
          ),
        ],
      ),
      body: sharedPrefEmail == null
          ? Center(child: CircularProgressIndicator()) // Loading until email is fetched
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('notifications')
                  .where('email', isEqualTo: sharedPrefEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'There is no notification for now',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                // Sort the notifications by timestamp in descending order
                final notifications = snapshot.data!.docs;
                notifications.sort((a, b) =>
                    (b['timestamp'] as Timestamp).compareTo(a['timestamp'] as Timestamp));

                return _showDetails && _selectedNotification != null
                    ? _buildNotificationDetails(_selectedNotification!)
                    : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notificationData = notifications[index].data() as Map<String, dynamic>;
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  notificationData['title'] ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  notificationData['description'] ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                  _formatTimestamp(notificationData['timestamp']),
                                ),
                                onTap: () {
                                  setState(() {
                                    _showDetails = true;
                                    _selectedNotification = notificationData;
                                  });
                                },
                              ),
                              Divider(),
                            ],
                          );
                        },
                      );
              },
            ),
    );
  }

  // Format the timestamp to display as time
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return "No time available"; // Fallback text when timestamp is null
    }

    DateTime dateTime = (timestamp as Timestamp).toDate();
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  // Function to display notification details
  Widget _buildNotificationDetails(Map<String, dynamic> notification) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['title'] ?? '',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            notification['description'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            'Time: ${_formatTimestamp(notification['timestamp'])}',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showDetails = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(127, 61, 255, 1),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              "Back to notifications",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Function to mark all notifications as read
  void _markAllRead() {
    final snackBar = SnackBar(
      content: Text('All notifications marked as read'),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Function to remove all notifications
  // Function to remove all notifications for the current user's email
void _removeAll() async {
  if (sharedPrefEmail == null) return;

  final batch = _firestore.batch();
  final notifications = await _firestore
      .collection('notifications')
      .where('email', isEqualTo: sharedPrefEmail)
      .get();

  for (var doc in notifications.docs) {
    batch.delete(doc.reference);
  }
  await batch.commit();

  final snackBar = SnackBar(
    content: Text('All notifications removed'),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
}