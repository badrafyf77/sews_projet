// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyLine extends StatelessWidget {
  const MyLine({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(4.0),
      child: Container(
        color: Colors.grey,
        height: 1,
      ),
    );
  }
}

class MyVerticalLine extends StatelessWidget {
  final double height;
  final Color color;
  const MyVerticalLine({
    Key? key,
    this.height = 80,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: VerticalDivider(
        color: color,
        thickness: 1.5,
      ),
    );
  }
}
