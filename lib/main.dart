import 'package:flutter/material.dart';
import 'screens/booking/booking_screen.dart';
import 'screens/location/tracking_screen.dart';
import 'screens/booking/booking_confirmation_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truck Hailing App',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      initialRoute: '/',
      routes: {
        '/': (context) => BookingScreen(),
        '/tracking': (context) => TrackingScreen(),
        '/confirmation': (context) => BookingConfirmationScreen(),
      },
    );
  }
}
