// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final Widget widget;
  const CustomAppbar({
    Key? key,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Row(
        children: [
          Expanded(
            child: MoveWindow(
              child: Row(
                children: [
                  widget,
                ],
              ),
            ),
          ),
          const WindowButtons(),
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(),
      ],
    );
  }
}

final buttonColors = WindowButtonColors(
  iconNormal: const Color(0xff253288),
  mouseOver: const Color(0xff253288),
  mouseDown: const Color(0xff253288),
  iconMouseOver: const Color(0xFFFFFFFF),
  iconMouseDown: const Color(0xFFFFFFFF),
);
