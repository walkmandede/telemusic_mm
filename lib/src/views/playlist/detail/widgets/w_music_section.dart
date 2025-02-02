import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/views/music_player/each_music_display_widget.dart';
import 'package:telemusic_v2/src/views/playlist/detail/c_playlist_detail_page_controller.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import '../../../../../utils/constants/app_constants.dart';

class PlaylistDetailMusicSection extends StatelessWidget {
  const PlaylistDetailMusicSection({super.key});

  @override
  Widget build(BuildContext context) {
    PlaylistDetailPageController playlistDetailPageController = Get.find();

    if (playlistDetailPageController.playlistModel.songList.isEmpty) {
      return SizedBox(
        width: Get.width,
        child: const AspectRatio(
          aspectRatio: 4 / 3,
          child: Center(
            child: Text("No musics for this artist yet!"),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
          left: AppConstants.basePadding,
          right: AppConstants.basePadding,
          top: AppConstants.basePadding),
      child: SizedBox(
          width: Get.width,
          child: Column(
            children: [
              ...playlistDetailPageController.playlistModel.songList.map(
                (each) {
                  return EachMusicDisplayWidget(
                    musicModel: each,
                    serialNo: playlistDetailPageController
                            .playlistModel.songList
                            .indexOf(each) +
                        1,
                    moreActions: [
                      PopupMenuItem(
                        onTap: () {
                          vibrateNow();
                          playlistDetailPageController.removeFromPlaylist(
                              musicModel: each);
                        },
                        child: Row(
                          children: [
                            SvgPicture.string(
                              AppSvgs.removeFromPlaylist,
                              colorFilter: const ColorFilter.mode(
                                  AppTheme.white, BlendMode.srcIn),
                            ),
                            (5.widthBox()),
                            const Text("Remove from this playlist"),
                          ],
                        ),
                      )
                    ],
                  );
                },
              )
            ],
          )),
    );
  }
}
