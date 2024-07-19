import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:tiqn/gValue.dart';

class MyWidget {
  static appbarMain() {
    return AppBar(
      leading: Image.asset('images/logo_white.png'),
      iconTheme: const IconThemeData(color: Colors.white, size: 40),
      shadowColor: Colors.grey,
      toolbarHeight: 50,
      leadingWidth: 120,
      centerTitle: true,
      elevation: 10,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFF3366FF),
                Color(0xFF00CCFF),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      ),
      title: Text(
        gValue.appName,
        style: const TextStyle(color: Colors.white, fontSize: 30),
      ),
      actions: const [
        Icon(Icons.home),
        Icon(Icons.account_box),
        Icon(Icons.settings),
        Icon(Icons.logout)
      ],
    );
  }

  static Widget digitalClock(BuildContext context) {
    return Container(
      width: 160,
      color: Colors.transparent,
      // color: const Color.fromRGBO(0, 0, 0, 0.122),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DateFormat('dd-MMM-yy').format(DateTime.now()),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          DigitalClock(
            digitAnimationStyle: Curves.fastEaseInToSlowEaseOut,
            areaDecoration: const BoxDecoration(color: Colors.transparent),
            hourMinuteDigitTextStyle: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
            secondDigitTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.black12,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
            colon: Text(
              ":",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
