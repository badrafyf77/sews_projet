// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../constants.dart';
import 'line.dart';

class MyContainer extends StatelessWidget {
  final String label;
  final Widget widget1;
  final Widget widget2;
  final Widget? widget3;

  const MyContainer({
    Key? key,
    required this.label,
    required this.widget1,
    required this.widget2,
    this.widget3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.3,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: kPrimaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(22)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const MyLine(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: widget1,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: widget2,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: widget3,
          ),
        ],
      ),
    );
  }
}

class MySizedBox extends StatelessWidget {
  final String text;
  const MySizedBox({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
