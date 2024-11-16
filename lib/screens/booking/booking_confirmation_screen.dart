import 'package:flutter/material.dart';
import 'package:vergoes_mobile_app/widgets/custom_button.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('You\'ve arrived'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
              ),
              title: Text('Handoko Mulyono'),
              subtitle: Text('Toyota HR-V - L-2323-RF'),
              trailing: Icon(Icons.info),
            ),
            SizedBox(height: 20),
            Text('How was your trip?',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5, (index) => Icon(Icons.star_border, size: 30)),
            ),
            SizedBox(height: 20),
            Divider(),
            // Trip Details
            ListTile(
              title: Text('Trip Details'),
              subtitle: Text('Aloha Cafe, 4342A Marisson Hotel'),
              trailing:
                  Text('+3023 Coins', style: TextStyle(color: Colors.green)),
            ),
            Spacer(),
            // Back and Download Bill Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  label: 'Back to home',
                  onPressed: () {
                    // Navigate to the home screen
                    Navigator.pop(context);
                  },
                ),
                CustomButton(
                  label: 'Download Bill',
                  onPressed: () {
                    // Trigger file download (implement file download logic here)
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
