import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

const kPrimaryColor = Color(0xff253288);
const kIcon = 'assets/images/sewsicon.png';

void myShowToast(BuildContext context, String text, Color color) {
  showToast(
    text,
    context: context,
    animation: StyledToastAnimation.fade,
    backgroundColor: color,
  );
}

final config = CalendarDatePicker2WithActionButtonsConfig(
      selectedDayHighlightColor: kPrimaryColor,
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
        color: Colors.blueGrey,
        fontWeight: FontWeight.bold,
      ),
    );