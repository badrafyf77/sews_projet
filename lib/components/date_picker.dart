import 'package:flutter/material.dart';

import 'package:sews_projet/constants.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class MyDatePicker extends StatefulWidget {
  final void Function()? onPressed;
  final String hintText;
  const MyDatePicker({
    Key? key,
    required this.onPressed,
    required this.hintText,
  }) : super(key: key);

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: AlwaysDisabledFocusNode(),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: widget.onPressed,
          icon: const Icon(
            Icons.calendar_today,
            color: kPrimaryColor,
          ),
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: kPrimaryColor),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            width: 1.5,
            color: kPrimaryColor,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            width: 1.5,
            color: kPrimaryColor,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            width: 1.5,
            color: kPrimaryColor,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  
}
