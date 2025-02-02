import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const double figmaWidth = 430;
const double figmaHeight = 932;

extension CustomString on Duration {
  String durationToTimeString() {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

extension CustomBox2 on int {
  Widget widthBox() {
    return SizedBox(width: toDouble());
  }

  Widget heightBox() {
    return SizedBox(height: toDouble());
  }
}

extension CustomBox on double {
  Widget widthBox() {
    return SizedBox(width: toDouble());
  }

  Widget heightBox() {
    return SizedBox(height: toDouble());
  }
}

extension CustomDateTime on DateTime {
  String getDateKey() {
    return toString().substring(0, 10);
  }

  String getMDY() {
    return DateFormat('MMM d,yyyy').format(DateTime.parse(toString()));
  }
}
