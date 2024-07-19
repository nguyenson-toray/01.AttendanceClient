import 'package:flutter/material.dart';

class PayrollUI extends StatefulWidget {
  const PayrollUI({super.key});

  @override
  State<PayrollUI> createState() => _PayrollUIState();
}

class _PayrollUIState extends State<PayrollUI>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Icon(Icons.money),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
