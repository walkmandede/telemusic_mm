import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/views/album/c_album_detail_page_controller.dart';
import 'package:telemusic_v2/src/views/playlist/detail/c_playlist_detail_page_controller.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

class PlaylistDetailActionsSection extends StatelessWidget {
  const PlaylistDetailActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    PlaylistDetailPageController playlistDetailPageController = Get.find();
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
                      playlistDetailPageController.playlistModel.playlistName,
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PopupMenuButton(
                        icon: SvgPicture.string(
                          AppSvgs.moreDotsVertical,
                          colorFilter: const ColorFilter.mode(
                              AppTheme.lightGray, BlendMode.srcIn),
                        ),
                        onOpened: () {
                          vibrateNow();
                        },
                        onCanceled: () {
                          vibrateNow();
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: const Text("Delete this playlist"),
                              onTap: () {
                                vibrateNow();
                                DialogService().showConfirmDialog(
                                  context: Get.context!,
                                  label: "Are you sure?",
                                  yesLabel: "Delete",
                                  noLabel: "Cancel",
                                  onClickYes: () {
                                    vibrateNow();
                                    playlistDetailPageController
                                        .deletePlaylist();
                                  },
                                );
                              },
                            )
                          ];
                        },
                      ),
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
                              songs: playlistDetailPageController
                                  .playlistModel.songList
                                  .map((e) {
                                return e.convertToMediaItem();
                              }).toList(),
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
