import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vergoes_mobile_app/blocs/booking/booking_bloc.dart';
import 'package:vergoes_mobile_app/models/booking_details_model.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _selectedTruckType = 'Small Truck';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pickup Location Input
          TextFormField(
            controller: _pickupController,
            decoration: InputDecoration(labelText: 'Pickup Location'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a pickup location';
              }
              return null;
            },
          ),

          // Destination Input
          TextFormField(
            controller: _destinationController,
            decoration: InputDecoration(labelText: 'Destination'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a destination';
              }
              return null;
            },
          ),

          // Date Picker
          TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(labelText: 'Pickup Date'),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                _dateController.text = pickedDate.toIso8601String();
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please pick a date';
              }
              return null;
            },
          ),

          // Truck Type Dropdown
          DropdownButtonFormField<String>(
            value: _selectedTruckType,
            decoration: InputDecoration(labelText: 'Truck Type'),
            items: ['Small Truck', 'Medium Truck', 'Large Truck']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedTruckType = newValue!;
              });
            },
          ),

          // Submit Button
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, submit the booking request
                final bookingDetails = BookingDetails(
                  pickupLocation: _pickupController.text,
                  destination: _destinationController.text,
                  truckType: _selectedTruckType,
                  pickupDate: DateTime.parse(_dateController.text),
                );

                // Dispatch the booking event
                BlocProvider.of<BookingBloc>(context)
                    .add(CreateBookingEvent(bookingDetails));
              }
            },
            child: Text('Book Truck'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
