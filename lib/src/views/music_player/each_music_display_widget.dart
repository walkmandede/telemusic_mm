import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/audio_downloader.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/models/music_model.dart';
import 'package:telemusic_v2/src/views/_common/image_placeholder_widget.dart';
import 'package:telemusic_v2/src/views/album/c_album_detail_page_controller.dart';
import 'package:telemusic_v2/src/views/artist/detail/c_artist_detail_page_controller.dart';
import 'package:telemusic_v2/src/views/playlist/widgets/add_new_playlist_bs.dart';
import 'package:telemusic_v2/src/views/playlist/widgets/all_playlist_bs.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';
import 'package:telemusic_v2/utils/services/network/api_response_model.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

class EachMusicDisplayWidget extends StatelessWidget {
  final MusicModel musicModel;
  final List<MusicModel> playList;
  final int serialNo;
  final List<PopupMenuItem> moreActions;
  const EachMusicDisplayWidget(
      {super.key,
      required this.musicModel,
      required this.serialNo,
      this.playList = const [],
      this.moreActions = const []});

  @override
  Widget build(BuildContext context) {
    DataController dataController = Get.find();

    return InkWell(
      onTap: () {
        vibrateNow();
        audioHandler.playAllSongs(
            songs: playList.isEmpty
                ? [musicModel.convertToMediaItem()]
                : [...playList.map((e) => e.convertToMediaItem())],
            index: playList.isEmpty ? 0 : playList.indexOf(musicModel),
            xNetworkSong: true);
      },
      child: SizedBox(
        width: Get.width,
        child: AspectRatio(
          aspectRatio: 5,
          child: LayoutBuilder(
            builder: (a1, c1) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: c1.maxHeight * 0.1),
                child: Row(
                  children: [
                    SizedBox(
                      width: c1.maxWidth * 0.1,
                      child: Text(
                        serialNo.toString(),
                        style: const TextStyle(
                            fontSize: AppConstants.baseFontSizeL,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.white),
                      ),
                    ),
                    SizedBox(
                      height: c1.maxHeight,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CachedNetworkImage(
                          imageUrl: musicModel.image,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return const ImagePlaceholderWidget();
                          },
                        ),
                      ),
                    ),
                    (c1.maxWidth * 0.05).widthBox(),
                    Expanded(
                      child: Text(musicModel.audioTitle,
                          style: const TextStyle(
                              fontSize: AppConstants.baseFontSizeL,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.white)),
                    ),
                    (c1.maxWidth * 0.05).widthBox(),
                    PopupMenuButton(
                      icon: SvgPicture.string(
                        AppSvgs.moreDotsVertical,
                        colorFilter: const ColorFilter.mode(
                            AppTheme.white, BlendMode.srcIn),
                      ),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            onTap: () async {
                              vibrateNow();
                              await Future.delayed(
                                  const Duration(milliseconds: 100));
                              DialogService()
                                  .showLoadingDialog(context: Get.context!);
                              ApiResponseModel apiResponseModel =
                                  ApiResponseModel.getInstance();
                              try {
                                apiResponseModel = await ApiRepo()
                                    .toggleFavorite(
                                        musicId: musicModel.id.toString());
                              } catch (e) {
                                superPrint(e);
                              }
                              DialogService()
                                  .dismissDialog(context: Get.context!);
                              if (apiResponseModel.xSuccess) {
                                dataController.updateFavoriteList();
                                Get.showSnackbar(GetSnackBar(
                                  message: dataController.xIsFavorite(
                                          audioUrl: musicModel
                                              .convertToMediaItem()
                                              .id)
                                      ? "Added to favorites"
                                      : "Removed from favorites",
                                  duration: const Duration(milliseconds: 2000),
                                ));
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  message: apiResponseModel.message,
                                  duration: const Duration(milliseconds: 2000),
                                ));
                              }
                            },
                            child: Row(
                              children: [
                                SvgPicture.string(
                                  AppSvgs.musicFavorite,
                                  colorFilter: const ColorFilter.mode(
                                      AppTheme.white, BlendMode.srcIn),
                                ),
                                (5.widthBox()),
                                Text(dataController.xIsFavorite(
                                        audioUrl: musicModel.audioUrl)
                                    ? "Remove from favorites"
                                    : "Add to favorites"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () async {
                              vibrateNow();
                              Get.bottomSheet(AllPlaylistBottomSheet(
                                musicModel: musicModel,
                              ));
                            },
                            child: Row(
                              children: [
                                SvgPicture.string(
                                  AppSvgs.addToPlayList,
                                  colorFilter: const ColorFilter.mode(
                                      AppTheme.white, BlendMode.srcIn),
                                ),
                                (5.widthBox()),
                                const Text("Save to playlist"),
                              ],
                            ),
                          ),
                          if (false)
                            PopupMenuItem(
                              onTap: () async {
                                vibrateNow();
                                DataController dataController = Get.find();
                                final xPremium = dataController
                                    .currentUser.value!
                                    .xPremium();
                                if (xPremium) {
                                  DialogService().showConfirmDialog(
                                      context: context,
                                      label:
                                          "Please be a premium member to download this song");
                                  return;
                                }
                                ValueNotifier<int> current = ValueNotifier(-1);
                                ValueNotifier<int> max = ValueNotifier(-1);
                                AudioDownloader.downloadAudio(
                                  musicModel: musicModel,
                                  onReceivedProgress: (p0, p1) {
                                    current.value = p0;
                                    if (max.value != p1) {
                                      max.value = p1;
                                    } else {}

                                    if (p0 == p1) {
                                      DialogService()
                                          .dismissDialog(context: context);
                                    }
                                  },
                                );
                                Future.delayed(
                                    const Duration(milliseconds: 100));
                                DialogService().showCustomDialog(
                                    context: context,
                                    widget: ValueListenableBuilder(
                                      valueListenable: max,
                                      builder: (context, max, child) {
                                        return ValueListenableBuilder(
                                          valueListenable: current,
                                          builder: (context, current, child) {
                                            if (current == -1 || max == -1) {
                                              return const SizedBox.shrink();
                                            }
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                    "Downloading please wait"),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: current / max,
                                                  ),
                                                ),
                                                Text(
                                                    "${(current / max * 100).toInt().toString()} %"),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ));
                                // Get.dialog(Dialog(
                                //   backgroundColor: Colors.transparent,
                                //   child: ,
                                // ));
                              },
                              child: Row(
                                children: [
                                  SvgPicture.string(
                                    AppSvgs.download,
                                    colorFilter: const ColorFilter.mode(
                                        AppTheme.white, BlendMode.srcIn),
                                  ),
                                  (5.widthBox()),
                                  const Text("Download"),
                                ],
                              ),
                            ),
                          ...moreActions
                        ];
                      },
                    )
                    // IconButton(
                    //     onPressed: () {
                    //     },
                    //     icon: SvgPicture.string(
                    //       AppSvgs.moreDotsVertical,
                    //       colorFilter: const ColorFilter.mode(
                    //           AppTheme.white, BlendMode.srcIn),
                    //     ))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
