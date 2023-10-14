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
  const MyVerticalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 80,
      child: VerticalDivider(
        color: Colors.white,
        thickness: 1.5,
      ),
    );
  }
}
