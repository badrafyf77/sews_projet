// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../constants.dart';

class MyTextField extends StatefulWidget {
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final bool showPasswordIcon;
  const MyTextField({
    Key? key,
    this.focusNode,
    required this.validator,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.showPasswordIcon = false,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool showPassword = false;
  @override
  void initState() {
    showPassword = widget.obscureText;
    super.initState();
  }

  void toggle() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: showPassword,
      enableSuggestions: !showPassword,
      autocorrect: !showPassword,
      focusNode: widget.focusNode,
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: widget.showPasswordIcon
            ? IconButton(
                onPressed: () {
                  toggle();
                },
                icon: Icon(showPassword
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded),
                color: kPrimaryColor,
              )
            : const SizedBox(),
        hintText: widget.label,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
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
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.red,
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.red,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(
            width: 1.5,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
