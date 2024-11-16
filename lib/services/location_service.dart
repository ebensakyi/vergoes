import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<LocationData> getCurrentLocation() async {
    return await location.getLocation();
  }

  Future<String> fetchLocation() async {
    // Simulate GPS location fetch
    await Future.delayed(Duration(seconds: 1));
    return 'Aloha Cafe, 4342A Marisson Hotel'; // Mock location
  }
}
