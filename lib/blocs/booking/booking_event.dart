import 'package:vergoes_mobile_app/models/booking_details_model.dart';

abstract class BookingEvent {}

class CreateBookingEvent extends BookingEvent {
  final BookingDetails details;

  CreateBookingEvent(this.details);
}

// class CreateBookingEvent extends Equatable {
//   final Booking booking;

//   const CreateBookingEvent(this.booking);

//   @override
//   List<Object?> get props => [booking];
// }
