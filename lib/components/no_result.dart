// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoRestultAnimation extends StatefulWidget {
  final Size size;
  const NoRestultAnimation({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  State<NoRestultAnimation> createState() => _NoRestultAnimationState();
}

class _NoRestultAnimationState extends State<NoRestultAnimation> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: widget.size.height * 0.4,
            width: widget.size.width * 0.4,
            child: Lottie.asset('assets/no_result_animation.json'),
          ),
          const Text(
            'Aucun Resultat',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          )
        ],
      ),
    );
  }
}
