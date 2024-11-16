class LocationRepository {
  Future<String> getCurrentLocation() async {
    // Simulate a fake API call
    await Future.delayed(Duration(seconds: 2));
    return 'Fake Location: 37.7749° N, 122.4194° W';
  }
}
