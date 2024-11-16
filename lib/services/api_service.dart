import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vergoes_mobile_app/models/booking_model.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }

  Future<Booking> createBooking(Booking booking) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    return booking;
  }

  Future<void> cancelBooking(String bookingId) async {
    // Simulate cancel API call
    await Future.delayed(Duration(seconds: 1));
  }
}
