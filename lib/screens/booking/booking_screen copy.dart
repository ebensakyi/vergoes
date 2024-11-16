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
  LatLng? pickupLocation; // Track the pickup location
  LatLng? destinationLocation; // Track the destination location
  LatLng? currentLocation; // Track the current location
  late GoogleMapController mapController; // Controller for the Google Map

  final List<Map<String, String>> paymentMethods = [
    {
      'title': 'Cash',
      'image': Constants.cashImage,
    },
    {
      'title': 'Card Payment',
      'image': Constants.cardImage,
    },
    {
      'title': 'Mobile Payment',
      'image': Constants.mobileMoneyImage,
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get the current location
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return; // Location services are not enabled
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return; // Permissions are denied
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return; // Permissions are permanently denied
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = LatLng(
            position.latitude, position.longitude); // Set current location
      });
    } catch (e) {
      print("Error getting location: $e");
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
          // Google Map widget
          currentLocation != null
              ? GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    mapController.animateCamera(
                      CameraUpdate.newLatLngZoom(
                          currentLocation!, 14.0), // Zoom level
                    );
                  },
                  initialCameraPosition: CameraPosition(
                    target: currentLocation!,
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: currentLocation!,
                    ),
                  },
                  myLocationEnabled: true,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          // Draggable Bottom Sheet
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
          // Pickup and Destination selection combined into one text field
          InkWell(
            onTap: () async {
              // Navigate to full-screen location entry page and get the selected pickup and destination
              List<LatLng?>? result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FullScreenLocationEntry(),
                ),
              );

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
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pickupLocation != null && destinationLocation != null
                        ? 'Pickup: (${pickupLocation!.latitude}, ${pickupLocation!.longitude})\nDestination: (${destinationLocation!.latitude}, ${destinationLocation!.longitude})'
                        : 'Select Pickup & Destination',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle "Find Driver" action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Find Driver',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedPaymentMethod,
        hint: const Text("Select Payment Method"),
        isExpanded: true,
        underline: const SizedBox(),
        items: paymentMethods.map((Map<String, String> method) {
          return DropdownMenuItem<String>(
            value: method['title'],
            child: Row(
              children: [
                Image.asset(
                  method['image']!,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 8),
                Text(method['title']!),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value;
          });
        },
      ),
    );
  }

  Widget _vehicleOption(String title, String model, String color, String price,
      int capacity, String imagePath) {
    final isSelected = selectedVehicle == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedVehicle = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 80, height: 80),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? Colors.blue : Colors.black,
                    )),
                Text(model, style: const TextStyle(color: Colors.grey)),
                Text('Color: $color',
                    style: const TextStyle(color: Colors.grey)),
                Text('Capacity: $capacity',
                    style: const TextStyle(color: Colors.grey)),
                Text(price, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
