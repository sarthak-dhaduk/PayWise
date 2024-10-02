import 'package:flutter/material.dart';

class IconSearchPage extends StatefulWidget {
  @override
  _IconSearchPageState createState() => _IconSearchPageState();
}

class _IconSearchPageState extends State<IconSearchPage> {
  // A map of Flutter icon names and their corresponding icon data.
  final Map<String, IconData> _flutterIcons = {
    'ten_k': Icons.ten_k,
    'ten_mp': Icons.ten_mp,
    'eleven_mp': Icons.eleven_mp,
    'twelve_mp': Icons.twelve_mp,
    'thirteen_mp': Icons.thirteen_mp,
    'fourteen_mp': Icons.fourteen_mp,
  };

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter icons based on search query
    final filteredIcons = _flutterIcons.entries
        .where((entry) => entry.key.contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Flutter Icons'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Icons',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Adjust the number of columns
              ),
              itemCount: filteredIcons.length,
              itemBuilder: (context, index) {
                final iconName = filteredIcons[index].key;
                final iconData = filteredIcons[index].value;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(iconData),
                    SizedBox(height: 8),
                    Text(
                      iconName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
