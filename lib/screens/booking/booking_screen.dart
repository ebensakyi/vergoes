import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vergoes_mobile_app/screens/booking/fullscreen_location_entry.dart';
import 'package:vergoes_mobile_app/utils/constants.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? selectedVehicle;
  String? selectedPaymentMethod;
  LatLng? selectedLocation;
  LatLng? currentLocation;
  LatLng? pickupLocation;
  LatLng? destinationLocation;
  late GoogleMapController mapController;

  final List<Map<String, String>> paymentMethods = [
    {'title': 'Cash', 'image': Constants.cashImage},
    {'title': 'Card Payment', 'image': Constants.cardImage},
    {'title': 'Mobile Payment', 'image': Constants.mobileMoneyImage},
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Find your vehicle',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          currentLocation != null
              ? GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(currentLocation!, 14.0));
                  },
                  initialCameraPosition:
                      CameraPosition(target: currentLocation!, zoom: 14.0),
                  markers: {
                    Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: currentLocation!),
                  },
                  myLocationEnabled: true,
                )
              : const Center(child: CircularProgressIndicator()),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _bookingDetails(context),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _bookingDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              dynamic result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FullScreenLocationEntry(),
                ),
              );

              print(result);
              print(result[1]);

              if (result != null && result.length == 2) {
                setState(() {
                  pickupLocation = result[0]; // Update the pickup location
                  destinationLocation =
                      result[1]; // Update the destination location
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pickupLocation != null && destinationLocation != null
                        ? 'Pickup: (${pickupLocation!.latitude}, ${pickupLocation!.longitude})\nDestination: (${destinationLocation!.latitude}, ${destinationLocation!.longitude})'
                        : 'Select Pickup & Destination',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const Icon(Icons.edit, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Available options',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _vehicleOption('GoCab Medium', 'Toyota HR-V', 'White', '\$23.0', 4,
              Constants.truck1),
          const SizedBox(height: 8),
          _vehicleOption('GoCab Small', 'Honda Civic', 'White', '\$18.5', 2,
              Constants.truck2),
          const SizedBox(height: 16),
          const Text('Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _paymentMethodDropdown(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _confirmBooking,
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }

  Widget _vehicleOption(String title, String subtitle, String color,
      String price, int seats, String image) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedVehicle = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selectedVehicle == title ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selectedVehicle == title ? Colors.blue : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(image, width: 60, height: 60),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
                Text('Color: $color',
                    style: const TextStyle(color: Colors.grey)),
                Text('Price: $price',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Seats: $seats',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodDropdown() {
    return DropdownButton<String>(
      value: selectedPaymentMethod,
      hint: const Text('Select Payment Method'),
      isExpanded: true,
      items: paymentMethods.map((Map<String, String> paymentMethod) {
        return DropdownMenuItem<String>(
          value: paymentMethod['title'],
          child: Row(
            children: [
              Image.asset(paymentMethod['image']!, width: 24, height: 24),
              const SizedBox(width: 8),
              Text(paymentMethod['title']!),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
    );
  }

  void _confirmBooking() {
    if (pickupLocation != null &&
        destinationLocation != null &&
        selectedVehicle != null &&
        selectedPaymentMethod != null) {
      // Handle booking confirmation logic
    } else {
      // Show a message to the user to fill all fields
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
    }
  }
}
