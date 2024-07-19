import 'package:flutter/material.dart';

class Production extends StatefulWidget {
  const Production({super.key});

  @override
  State<Production> createState() => _ProductionState();
}

class _ProductionState extends State<Production> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      color: Colors.cyan,
      child: const Text('Production '),
    ));
  }
}
