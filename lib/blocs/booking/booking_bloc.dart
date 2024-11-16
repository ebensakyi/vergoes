import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vergoes_mobile_app/models/booking_details_model.dart';
import 'package:vergoes_mobile_app/repository/booking_repository.dart';
import '../../models/booking_model.dart';

// Booking Events
abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class CreateBookingEvent extends BookingEvent {
  final BookingDetails bookingDetails;

  const CreateBookingEvent(this.bookingDetails);
}

class CancelBookingEvent extends BookingEvent {
  final String bookingId;

  const CancelBookingEvent(this.bookingId);
}

// Booking States
abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final Booking booking;

  const BookingSuccess(this.booking);
}

class BookingFailure extends BookingState {
  final String error;

  const BookingFailure(this.error);
}

// Booking BLoC
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc({required this.bookingRepository}) : super(BookingInitial());

  @override
  Stream<BookingState> mapEventToState(BookingEvent event) async* {
    if (event is CreateBookingEvent) {
      yield BookingLoading();
      try {
        final booking =
            await bookingRepository.createBooking(BookingDetails.fromJson({
          'pickupLocation': "Accra",
          'destination': "Tamale",
          'truckType': "Double Axle",
          'pickupDate': DateTime.now().toIso8601String(),
        }));
        yield BookingSuccess(booking);
      } catch (e) {
        yield BookingFailure(e.toString());
      }
    } else if (event is CancelBookingEvent) {
      yield BookingLoading();
      try {
        await bookingRepository.cancelBooking(event.bookingId);
        yield BookingInitial();
      } catch (e) {
        yield BookingFailure(e.toString());
      }
    }
  }
}
