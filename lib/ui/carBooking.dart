import 'package:flutter/material.dart';

class CarBooking extends StatefulWidget {
  const CarBooking({super.key});

  @override
  State<CarBooking> createState() => _CarBookingState();
}

class _CarBookingState extends State<CarBooking> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: const Text('CarBooking '),
    ));
  }
}
