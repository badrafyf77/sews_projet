// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../constants.dart';

class MyButton extends StatelessWidget {
  final bool enable;
  final Function()? onPressed;
  final String textButton;
  final double padding;
  final Color color;
  const MyButton({
    Key? key,
    this.enable = true,
    required this.onPressed,
    required this.textButton,
    this.padding = 1,
    this.color = kPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: ElevatedButton(
        onPressed: enable ? onPressed : null,
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(enable ? color : Colors.grey),
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
