import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

const kPrimaryColor = Color(0xff253288);
const kIcon = 'assets/images/sewsicon.png';

void myShowToast(BuildContext context, String text,Color color) {
  showToast(
                        text,
                        context: context,
                        animation: StyledToastAnimation.sizeFade,
                        backgroundColor: color,
                      );
}
