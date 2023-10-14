import 'package:flutter/material.dart';

import '../constants.dart';

class MyTextButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  const MyTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return kPrimaryColor;
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return Colors.white;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
