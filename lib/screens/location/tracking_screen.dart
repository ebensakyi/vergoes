import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get ready, the driver will come soon'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display the map with tracking
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Center(
                child: Icon(Icons.map, size: 200, color: Colors.grey),
              ),
            ),
          ),
          // Driver Details
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  title: Text('Handoko'),
                  subtitle: Text('Toyota HR-V - L-2323-RF'),
                  trailing: Column(
                    children: [
                      Text('Medium Size'),
                      Text('05:21 Mins', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Divider(),
                Text('The driver will arrive soon',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
