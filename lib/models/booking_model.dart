class Booking {
  final String id;
  final String userId;
  final String truckType;
  final double price;
  final String pickupLocation;
  final String destination;
  final String date;

  Booking({
    required this.id,
    required this.userId,
    required this.truckType,
    required this.price,
    required this.pickupLocation,
    required this.destination,
    required this.date,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['userId'],
      truckType: json['truckType'],
      price: json['price'],
      pickupLocation: json['pickupLocation'],
      destination: json['destination'],
      date: json['date'],
    );
  }
}
