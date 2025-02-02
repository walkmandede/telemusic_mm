import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/models/artist_model.dart';
import 'package:telemusic_v2/src/views/artist/detail/c_artist_detail_page_controller.dart';
import 'package:telemusic_v2/src/views/music_player/each_music_display_widget.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

class ArtistDetailStreamCountSection extends StatefulWidget {
  const ArtistDetailStreamCountSection({super.key});

  @override
  State<ArtistDetailStreamCountSection> createState() =>
      _ArtistDetailStreamCountSectionState();
}

class _ArtistDetailStreamCountSectionState
    extends State<ArtistDetailStreamCountSection> {
  String formatLargeNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    ArtistDetailPageController artistDetailPageController = Get.find();
    return Padding(
      padding: const EdgeInsets.only(
          left: AppConstants.basePadding,
          right: AppConstants.basePadding,
          top: AppConstants.basePadding),
      child: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...artistDetailPageController
                    .artist.enumStreamChannelCountMap.entries
                    .map((entry) {
                  EnumStreamChannel enumChannel = entry.key;
                  final count = entry.value;
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            AppConstants.baseBorderRadius)),
                    margin: const EdgeInsets.only(
                        right: AppConstants.basePadding / 2),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(AppConstants.basePadding * 0.3),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: Get.width * 0.35,
                                child: AspectRatio(
                                  aspectRatio: 3.5 / 1,
                                  child: SvgPicture.string(
                                    enumChannel.icon,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              (AppConstants.basePadding * 0.25).heightBox(),
                              Text(
                                enumChannel.label,
                                style: const TextStyle(
                                    fontSize: AppConstants.baseFontSizeS),
                              ),
                              Text(
                                formatLargeNumber(count),
                                style: const TextStyle(
                                    color: AppTheme.primaryYellow,
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppConstants.baseFontSizeL),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                })
              ],
            ),
          )),
    );
  }
}
