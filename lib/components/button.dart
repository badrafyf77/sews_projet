// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../constants.dart';

class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final String textButton;
  final double padding;
  const MyButton({
    Key? key,
    required this.onPressed,
    required this.textButton,
    this.padding = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(kPrimaryColor),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            textButton,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
