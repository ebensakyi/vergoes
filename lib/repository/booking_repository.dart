import 'package:vergoes_mobile_app/models/booking_details_model.dart';

import '../services/api_service.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final ApiService apiService;

  BookingRepository(this.apiService);

  Future<Booking> createBooking(BookingDetails details) async {
    // final response = await apiService.post('/bookings', details.toJson());
    // return Booking.fromJson(response);
    return Booking(
      id: '456',
      userId: '123',
      truckType: '789',
      pickupLocation: "Accra",
      destination: "Sunyani",
      date: DateTime.now().toIso8601String(),
      price: 100.0, // Fake data
    );
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    final response = await apiService.get('/users/$userId/bookings');
    return (response as List).map((json) => Booking.fromJson(json)).toList();
  }

  //  Future<Booking> createBooking(Booking booking) async {
  //   return await apiService.createBooking(booking);
  // }

  Future<void> cancelBooking(String bookingId) async {
    await apiService.cancelBooking(bookingId);
  }
}
