import 'package:vergoes_mobile_app/models/booking_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final Booking booking;
  BookingSuccess(this.booking);
}

class BookingFailure extends BookingState {
  final String error;
  BookingFailure(this.error);
}
