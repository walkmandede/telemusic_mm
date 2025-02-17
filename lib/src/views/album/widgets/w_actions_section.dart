import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/views/album/c_album_detail_page_controller.dart';
import 'package:telemusic_v2/src/views/artist/detail/c_artist_detail_page_controller.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

class AlbumnDetailActionsSection extends StatelessWidget {
  const AlbumnDetailActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    AlbumDetailPageController albumDetailPageController = Get.find();
    return Padding(
      padding: const EdgeInsets.only(
          left: AppConstants.basePadding,
          right: AppConstants.basePadding,
          top: AppConstants.basePadding),
      child: SizedBox(
          width: Get.width,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //artistDetail
                  Expanded(
                    child: Text(
                      albumDetailPageController.albumModel.name,
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // IconButton(
                      //     onPressed: () {
                      //       vibrateNow();
                      //     },
                      //     icon: SvgPicture.string(
                      //       AppSvgs.moreDotsVertical,
                      //       colorFilter: const ColorFilter.mode(
                      //           AppTheme.lightGray, BlendMode.srcIn),
                      //     )),
                      ElevatedButton(
                          onPressed: () {
                            vibrateNow();
                            audioHandler.toggleShuffle();
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: const CircleBorder(),
                              backgroundColor: Colors.transparent),
                          child: ValueListenableBuilder(
                            valueListenable:
                                audioHandler.musicPlayingState.xShuffle,
                            builder: (context, xShuffle, child) {
                              return SvgPicture.string(
                                AppSvgs.shuffleIcon,
                                colorFilter: ColorFilter.mode(
                                    xShuffle
                                        ? AppTheme.primaryYellow
                                        : AppTheme.lightGray,
                                    BlendMode.srcIn),
                              );
                            },
                          )),
                      ElevatedButton(
                        onPressed: () {
                          vibrateNow();

                          audioHandler.playAllSongs(
                              songs:
                                  albumDetailPageController.allMusics.map((e) {
                                return e.convertToMediaItem();
                              }).toList(),
                              index: 0,
                              xNetworkSong: true);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder()),
                        child: SvgPicture.string(AppSvgs.playFilled),
                      ),
                    ],
                  ),
                ],
              )
            ],
          )),
    );
  }
}
