class BookingDetails {
  final String pickupLocation;
  final String destination;
  final String truckType;
  final DateTime pickupDate;

  BookingDetails({
    required this.pickupLocation,
    required this.destination,
    required this.truckType,
    required this.pickupDate,
  });

  Map<String, dynamic> toJson() => {
        'pickupLocation': pickupLocation,
        'destination': destination,
        'truckType': truckType,
        'pickupDate': pickupDate.toIso8601String(),
      };

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      pickupLocation: json['pickupLocation'],
      destination: json['destination'],
      truckType: json['truckType'],
      pickupDate: json['pickupDate'],
    );
  }
}
