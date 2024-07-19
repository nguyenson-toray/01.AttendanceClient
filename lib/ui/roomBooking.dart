import 'package:flutter/material.dart';

class RoomBooking extends StatefulWidget {
  const RoomBooking({super.key});

  @override
  State<RoomBooking> createState() => _RoomBookingState();
}

class _RoomBookingState extends State<RoomBooking> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      color: Colors.yellow,
      child: const Text('RoomBooking '),
    ));
  }
}
