import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';

class ImagePlaceholderWidget extends StatelessWidget {
  const ImagePlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.string(
        AppSvgs.noImagePlaceHolder,
        width: 35,
        height: 35,
        fit: BoxFit.contain,
      ),
    );
  }
}
