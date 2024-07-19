import 'package:flutter/material.dart';

class GateControl extends StatefulWidget {
  const GateControl({super.key});

  @override
  State<GateControl> createState() => _GateControlState();
}

class _GateControlState extends State<GateControl> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: const Text('GateControl '),
    ));
  }
}
