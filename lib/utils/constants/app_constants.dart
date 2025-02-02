import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppConstants {
  static const double basePadding = 20;
  static const double baseButtonHeight = 50;
  static const double baseButtonHeightL = 60;
  static const double baseButtonHeightS = 30;
  static const double baseButtonHeightMS = 40;
  static const double basePaddingL = 20;
  static const double baseBorderRadius = 10;
  static const double baseBorderRadiusS = 8;
  static const double baseFontSizeM = 14;
  static const double baseFontSizeS = 12;
  static const double baseFontSizeXs = 10;
  static const double baseFontSizeL = 16;
  static const double baseFontSizeXL = 20;
  static const double baseFontSizeXXL = 26;

  //functions
  static EdgeInsets getBaseScaffoldPadding(
      {bool top = true,
      bool bottom = true,
      bool left = true,
      bool right = true}) {
    return EdgeInsets.only(
      left: left ? AppConstants.basePadding : 0,
      right: right ? AppConstants.basePadding : 0,
      top: top ? AppConstants.basePadding + (Get.mediaQuery.padding.top) : 0,
      bottom: bottom
          ? AppConstants.basePadding + (Get.mediaQuery.padding.bottom)
          : 0,
    );
  }
}
