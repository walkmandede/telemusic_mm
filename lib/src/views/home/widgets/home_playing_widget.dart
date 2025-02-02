import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

class HomePlayingWidget extends StatelessWidget {
  const HomePlayingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: DecoratedBox(
          decoration: BoxDecoration(color: AppTheme.primaryYellow)),
    );
  }
}
