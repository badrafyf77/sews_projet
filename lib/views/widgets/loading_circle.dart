// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingAnimation extends StatelessWidget {
  final Color color;
  final double size;
  const LoadingAnimation({
    Key? key,
    this.color = Colors.grey,
    this.size = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        height: size * 3.3,
        width: size * 3.3,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SpinKitThreeBounce(
              color: color,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}
