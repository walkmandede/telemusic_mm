import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/views/_common/image_placeholder_widget.dart';
import 'package:telemusic_v2/src/views/music_player/c_music_player_page_controller.dart';
import 'package:telemusic_v2/src/views/music_player/each_music_display_widget.dart';
import 'package:telemusic_v2/src/views/music_player/music_player_page.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

class MusicPlayerWidget extends StatelessWidget {
  const MusicPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    MusicPlayerPageController musicPlayerPageController = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.basePadding),
      child: ValueListenableBuilder(
        valueListenable: audioHandler.musicPlayingState.xLoading,
        builder: (context, xLoading, child) {
          if (xLoading) {
            return SizedBox(
              width: Get.width,
              height: musicPlayerPageController.playingWidgetHeight,
              child: const Card(
                margin: EdgeInsets.zero,
                child: Center(
                  child: Text("Loading please wait ..."),
                ),
              ),
            );
          } else {
            return ValueListenableBuilder(
                valueListenable:
                    audioHandler.musicPlayingState.currentMediaItem,
                builder: (context, currentMediaItem, _) {
                  if (currentMediaItem == null) {
                    return const SizedBox.shrink();
                  }
                  return ValueListenableBuilder(
                      valueListenable:
                          audioHandler.musicPlayingState.currentPlaybackState,
                      builder: (context, currentPlaybackState, _) {
                        return InkWell(
                          onTap: () {
                            vibrateNow();
                            Get.to(() => const MusicPlayerPage());
                          },
                          child: SizedBox(
                            width: double.infinity,
                            height:
                                musicPlayerPageController.playingWidgetHeight,
                            child: LayoutBuilder(
                              builder: (a1, c1) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: Get.width,
                                        child: Card(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: AppTheme.darkGray
                                                        .withOpacity(0.8),
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppConstants
                                                            .baseBorderRadius)),
                                            margin: EdgeInsets.zero,
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          c1.maxHeight * 0.15,
                                                      vertical:
                                                          c1.maxHeight * 0.1),
                                                  child: Row(
                                                    children: [
                                                      AspectRatio(
                                                        aspectRatio: 1,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: currentMediaItem
                                                                      .artUri ==
                                                                  null
                                                              ? ""
                                                              : currentMediaItem
                                                                  .artUri
                                                                  .toString(),
                                                          errorWidget: (context,
                                                              url, error) {
                                                            return const ImagePlaceholderWidget();
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      c1.maxHeight *
                                                                          0.1),
                                                          child: Text(
                                                            currentMediaItem
                                                                .title,
                                                            style: const TextStyle(
                                                                color: AppTheme
                                                                    .white,
                                                                fontSize:
                                                                    AppConstants
                                                                        .baseFontSizeL),
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                      if (currentPlaybackState !=
                                                          null)
                                                        InkWell(
                                                          onTap: () {
                                                            if (currentPlaybackState
                                                                .playing) {
                                                              audioHandler
                                                                  .pause();
                                                            } else {
                                                              audioHandler
                                                                  .play();
                                                            }
                                                          },
                                                          child:
                                                              SvgPicture.string(
                                                            currentPlaybackState
                                                                    .playing
                                                                ? AppSvgs
                                                                    .pauseFilled
                                                                : AppSvgs
                                                                    .playFilled,
                                                            colorFilter:
                                                                const ColorFilter
                                                                    .mode(
                                                                    AppTheme
                                                                        .white,
                                                                    BlendMode
                                                                        .srcIn),
                                                          ),
                                                        ),
                                                      (10.widthBox()),
                                                      InkWell(
                                                        onTap: () {
                                                          audioHandler
                                                              .closePlayer();
                                                        },
                                                        child: Icon(Icons
                                                            .clear_rounded),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                c1.maxHeight *
                                                                    0.15,
                                                            vertical:
                                                                c1.maxHeight *
                                                                    0.025),
                                                    child:
                                                        ValueListenableBuilder(
                                                      valueListenable:
                                                          audioHandler
                                                              .musicPlayingState
                                                              .duration,
                                                      builder: (context,
                                                          duration, child) {
                                                        return ValueListenableBuilder(
                                                          valueListenable:
                                                              audioHandler
                                                                  .musicPlayingState
                                                                  .position,
                                                          builder: (context,
                                                              position, child) {
                                                            if (duration ==
                                                                    null ||
                                                                position ==
                                                                    null) {
                                                              return const SizedBox
                                                                  .shrink();
                                                            }
                                                            return SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 2,
                                                              child:
                                                                  LayoutBuilder(
                                                                builder:
                                                                    (a2, c2) {
                                                                  final percentage = position
                                                                          .inSeconds /
                                                                      duration
                                                                          .inSeconds;
                                                                  if (percentage
                                                                          .toString() ==
                                                                      "NaN") {
                                                                    return const SizedBox
                                                                        .shrink();
                                                                  }
                                                                  return LinearProgressIndicator(
                                                                    value:
                                                                        percentage,
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      });
                });
          }
        },
      ),
    );
  }
}
