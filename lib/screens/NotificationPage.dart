import 'package:flutter/material.dart';
import 'package:paywise/screens/HomeScreen.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Sample list of notifications
  final List<Map<String, String>> notifications = [
    {
      'title': 'Shopping budget has exceeded the limit',
      'subtitle':
          'Your Shopping budget has exceeded the limit. Please adjust your spending.',
      'time': '19:30',
    },
    {
      'title': 'Utilities budget has exceeded the limit',
      'subtitle':
          'Your Utilities budget has exceeded the limit. Please adjust your expenses accordingly.',
      'time': '19:30',
    },
  ];

  bool _showDetails = false;
  Map<String, String>? _selectedNotification;

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
            position: PopupMenuPosition.under, // Show popup menu after AppBar
          ),
        ],
      ),
      body: _showDetails && _selectedNotification != null
          ? _buildNotificationDetails(_selectedNotification!)
          : notifications.isEmpty
              ? Center(
                  child: Text(
                    'There is no notification for now',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            notifications[index]['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            notifications[index]['subtitle']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(notifications[index]['time']!),
                          onTap: () {
                            setState(() {
                              _showDetails = true;
                              _selectedNotification = notifications[index];
                            });
                          },
                        ),
                        Divider(), // Added divider between list items
                      ],
                    );
                  },
                ),
    );
  }

  // Function to display notification details
  Widget _buildNotificationDetails(Map<String, String> notification) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['title']!,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            notification['subtitle']!,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Text(
            'Time: ${notification['time']}',
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
    // Customizing SnackBar with border radius and margin
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
  void _removeAll() {
    setState(() {
      notifications.clear();
    });
    // Customizing SnackBar with border radius and margin
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
