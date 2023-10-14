import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        height: 100,
        width: 100,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: SpinKitThreeBounce(
              color: Colors.grey,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
