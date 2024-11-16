import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:vergoes_mobile_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class FullScreenLocationEntry extends StatefulWidget {
  const FullScreenLocationEntry({Key? key}) : super(key: key);

  @override
  _FullScreenLocationEntryState createState() =>
      _FullScreenLocationEntryState();
}

class _FullScreenLocationEntryState extends State<FullScreenLocationEntry> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  String? pickupAddress; // Store the pickup address
  String? destinationAddress; // Store the destination address

  // Function to fetch current location
  Future<void> _setCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Reverse geocode the coordinates into a human-readable address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address =
            "${place.subAdministrativeArea ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
        setState(() {
          pickupController.text = address; // Set the pickup address
          pickupAddress = address; // Store the pickup address
        });
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _setCurrentLocation(); // Set the current location in the pickup field
  }

  // Function to fetch latitude and longitude from place_id
  Future<String?> _getAddressFromPlaceId(String placeId) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Constants.GOOGLE_API_KEY}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['result'] != null) {
        return data['result']
            ['formatted_address']; // Return the formatted address
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Locations'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GooglePlaceAutoCompleteTextField(
              textEditingController: pickupController,
              googleAPIKey: Constants.GOOGLE_API_KEY,
              inputDecoration: const InputDecoration(
                labelText: 'Pickup Location',
                border: OutlineInputBorder(),
              ),
              debounceTime: 800,
              countries: ["gh"],
              isLatLngRequired: false,
              getPlaceDetailWithLatLng: (Prediction prediction) async {
                pickupAddress =
                    await _getAddressFromPlaceId(prediction.placeId!);
              },
              itemClick: (Prediction prediction) {
                pickupController.text = prediction.description!;
                pickupController.selection = TextSelection.fromPosition(
                  TextPosition(offset: prediction.description!.length),
                );
              },
            ),
            const SizedBox(height: 16),
            GooglePlaceAutoCompleteTextField(
              textEditingController: destinationController,
              googleAPIKey: Constants.GOOGLE_API_KEY,
              inputDecoration: const InputDecoration(
                labelText: 'Destination Location',
                border: OutlineInputBorder(),
              ),
              debounceTime: 800,
              countries: ["gh"],
              isLatLngRequired: false,
              getPlaceDetailWithLatLng: (Prediction prediction) async {
                destinationAddress =
                    await _getAddressFromPlaceId(prediction.placeId!);
              },
              itemClick: (Prediction prediction) {
                destinationController.text = prediction.description!;
                destinationController.selection = TextSelection.fromPosition(
                  TextPosition(offset: prediction.description!.length),
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint([pickupAddress, destinationAddress] as String?);
                  // Return both pickup and destination addresses
                  Navigator.pop(context, [pickupAddress, destinationAddress]);
                },
                child: const Text('Confirm Locations'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
