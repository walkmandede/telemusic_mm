import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/ads/ads_handler.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/views/_common/image_placeholder_widget.dart';
import 'package:telemusic_v2/utils/constants/app_assets.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';
import 'package:telemusic_v2/utils/services/network/api_response_model.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

import 'c_music_player_page_controller.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with TickerProviderStateMixin {
  late AnimationController rotationAnimation;
  DataController dataController = Get.find();
  MusicPlayerPageController musicPlayerPageController = Get.find();
  AdsHandler adsHandler = Get.find();

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  @override
  void dispose() {
    rotationAnimation.dispose();
    super.dispose();
  }

  _initLoad() async {
    rotationAnimation =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    rotationAnimation.repeat();
    adsHandler.loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox.expand(
        child: ValueListenableBuilder(
          valueListenable: audioHandler.musicPlayingState.currentMediaItem,
          builder: (context, currentMediaItem, child) {
            if (currentMediaItem == null) {
              return SizedBox.fromSize();
            } else {
              return SizedBox.expand(
                child: LayoutBuilder(
                  builder: (a1, c1) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                          bottom: Get.mediaQuery.padding.bottom),
                      child: Column(
                        children: [
                          musicPlayingWidget(
                              size: Size(c1.maxWidth, c1.maxHeight)),
                          queueWidget(),
                          commentSections(),
                          metaDisplay(),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget queueWidget() {
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
                left: AppConstants.basePadding,
                right: AppConstants.basePadding,
                bottom: AppConstants.basePadding),
            child: Text("Current Queue"),
          ),
          ValueListenableBuilder(
            valueListenable: audioHandler.musicPlayingState.queue,
            builder: (context, currentPlaylist, child) {
              if (currentPlaylist.isEmpty) {
                return const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("There is no musics in the queue yet."),
                );
              }
              return ValueListenableBuilder(
                valueListenable:
                    audioHandler.musicPlayingState.currentMediaItem,
                builder: (context, currentMediaItem, child) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        (AppConstants.basePadding).widthBox(),
                        ...currentPlaylist.map((each) {
                          final xNowPlaying = each == currentMediaItem;
                          return InkWell(
                            onTap: () {
                              vibrateNow();
                              audioHandler.playDesiredSong(
                                  mediaItem: each, xNetworkSong: true);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: AppConstants.basePadding / 2),
                              child: SizedBox(
                                width: Get.width * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 4 / 3,
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.baseBorderRadius),
                                            side: BorderSide(
                                                color: !xNowPlaying
                                                    ? Colors.transparent
                                                    : AppTheme.primaryYellow)),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.baseBorderRadius),
                                          child: CachedNetworkImage(
                                            imageUrl: each.artUri.toString(),
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url,
                                                    error) =>
                                                const ImagePlaceholderWidget(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      each.title,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: xNowPlaying
                                            ? AppTheme.primaryYellow
                                            : AppTheme.white,
                                      ),
                                    ),
                                    Text(
                                      each.artist ?? "-",
                                      style: const TextStyle(
                                          fontSize: AppConstants.baseFontSizeS),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList()
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget commentSections() {
    return const SizedBox.shrink();
  }

  Widget musicPlayingWidget({required Size size}) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: LayoutBuilder(
        builder: (a1, c1) {
          return Column(
            children: [
              Expanded(
                child: musicImageWidget(),
              ),
              Expanded(
                child: controlPanel(),
              ),
              (Get.mediaQuery.padding.bottom).heightBox(),
            ],
          );
        },
      ),
    );
  }

  Widget controlPanel() {
    final mediaItem = audioHandler.musicPlayingState.currentMediaItem.value!;
    return SizedBox.expand(
      child: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.basePadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mediaItem.title,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: AppConstants.baseFontSizeXL,
                            color: AppTheme.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        mediaItem.artist ?? "-",
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: AppConstants.baseFontSizeL,
                            color: AppTheme.lightGray,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.basePadding,
                vertical: AppConstants.basePadding),
            child: ValueListenableBuilder(
              valueListenable: audioHandler.musicPlayingState.duration,
              builder: (context, duration, child) {
                return ValueListenableBuilder(
                  valueListenable: audioHandler.musicPlayingState.position,
                  builder: (context, position, child) {
                    double percentage = 0;
                    try {
                      percentage = position!.inSeconds / duration!.inSeconds;
                    } catch (_) {}
                    return Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable:
                              audioHandler.musicPlayingState.xLoading,
                          builder: (context, xLoading, child) {
                            if (xLoading ||
                                percentage.toString() == "NaN" ||
                                percentage.toString() == "Infinity") {
                              return const SizedBox.shrink();
                            }
                            return SizedBox(
                              width: Get.width,
                              child: Slider(
                                value: percentage,
                                min: 0,
                                max: 1,
                                divisions: 100,
                                onChanged: (value) async {
                                  vibrateNow();
                                  audioHandler.pause();
                                  await audioHandler.changePosition(value);
                                  audioHandler.play();
                                },
                              ),
                            );
                          },
                        ),
                        if (duration != null && position != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(position.durationToTimeString()),
                              Text(duration.durationToTimeString()),
                            ],
                          )
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.basePadding),
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: audioHandler.musicPlayingState.xShuffle,
                    builder: (context, xShuffle, child) {
                      return IconButton(
                          onPressed: () {
                            vibrateNow();
                            audioHandler.toggleShuffle();
                          },
                          icon: SvgPicture.string(
                            AppSvgs.shuffleIcon,
                            colorFilter: ColorFilter.mode(
                                xShuffle
                                    ? AppTheme.primaryYellow
                                    : AppTheme.darkGray,
                                BlendMode.srcIn),
                          ));
                    },
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: audioHandler.musicPlayingState.queue,
                    builder: (context, currentPlaylist, child) {
                      final xHasPrev = audioHandler.xHasPrevSongs();
                      return IconButton(
                          onPressed: () {
                            vibrateNow();
                            audioHandler.skipToPrevious();
                          },
                          icon: SvgPicture.string(
                            AppSvgs.previous,
                            colorFilter: ColorFilter.mode(
                                xHasPrev ? AppTheme.white : AppTheme.darkGray,
                                BlendMode.srcIn),
                          ));
                    },
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable:
                        audioHandler.musicPlayingState.currentPlayerstate,
                    builder: (context, currentPlayerstate, child) {
                      final xPlaying = currentPlayerstate == null
                          ? false
                          : currentPlayerstate.playing;
                      return IconButton(
                          onPressed: () {
                            vibrateNow();
                            audioHandler.togglePlayPause();
                          },
                          icon: SvgPicture.string(
                            xPlaying ? AppSvgs.pauseFilled : AppSvgs.playFilled,
                            colorFilter: const ColorFilter.mode(
                                AppTheme.white, BlendMode.srcIn),
                          ));
                    },
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: audioHandler.musicPlayingState.queue,
                    builder: (context, currentPlaylist, child) {
                      final xHasNext = audioHandler.xHasNextSong();
                      return IconButton(
                          onPressed: () {
                            vibrateNow();
                            audioHandler.skipToNext();
                          },
                          icon: SvgPicture.string(
                            AppSvgs.next,
                            colorFilter: ColorFilter.mode(
                                xHasNext ? AppTheme.white : AppTheme.darkGray,
                                BlendMode.srcIn),
                          ));
                    },
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: dataController.favoriteList,
                    builder: (context, favoriteList, child) {
                      return IconButton(
                          onPressed: () async {
                            vibrateNow();
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            DialogService()
                                .showLoadingDialog(context: Get.context!);
                            ApiResponseModel apiResponseModel =
                                ApiResponseModel.getInstance();
                            try {
                              apiResponseModel = await ApiRepo().toggleFavorite(
                                  musicId: mediaItem.extras!["id"].toString());
                            } catch (e) {
                              superPrint(e);
                            }
                            DialogService()
                                .dismissDialog(context: Get.context!);
                            if (apiResponseModel.xSuccess) {
                              await dataController.updateFavoriteList();
                              Get.showSnackbar(GetSnackBar(
                                message: dataController.xIsFavorite(
                                        audioUrl: mediaItem.id)
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
                          icon: SvgPicture.string(
                            AppSvgs.musicFavorite,
                            colorFilter: ColorFilter.mode(
                                dataController.xIsFavorite(
                                        audioUrl: mediaItem.id)
                                    ? AppTheme.primaryYellow
                                    : AppTheme.lightGray,
                                BlendMode.srcIn),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget musicImageWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            vibrateNow();
            if (audioHandler
                .musicPlayingState.currentPlaybackState.value!.playing) {
              audioHandler.pause();
            } else {
              audioHandler.play();
            }
          },
          child: ValueListenableBuilder(
              valueListenable:
                  audioHandler.musicPlayingState.currentPlayerstate,
              builder: (context, currentPlayerstate, _) {
                if (currentPlayerstate != null) {
                  if (currentPlayerstate.playing) {
                    rotationAnimation.repeat();
                  } else {
                    rotationAnimation.stop();
                  }
                }
                return AnimatedBuilder(
                  animation: rotationAnimation,
                  builder: (context, child) {
                    final animatedValue = rotationAnimation.value;
                    final rotationAngle = animatedValue * 2 * (22 / 7);
                    return Transform.rotate(
                      angle: rotationAngle,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: Get.width * 0.75,
                            height: Get.width * 0.75,
                            child: Card(
                              margin: EdgeInsets.zero,
                              shape: const CircleBorder(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000000),
                                child: CachedNetworkImage(
                                  imageUrl: audioHandler.musicPlayingState
                                      .currentMediaItem.value!.artUri
                                      .toString(),
                                  errorWidget: (context, url, error) {
                                    return const ImagePlaceholderWidget();
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.2,
                            height: Get.width * 0.2,
                            child: Card(
                              margin: EdgeInsets.zero,
                              shape: CircleBorder(),
                              color: AppTheme.primaryBlack,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000000),
                                child: Image.asset(AppAssets.appLogo),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
        ),
        adsHandler.getBannerAdWidget()
      ],
    );
  }

  Widget metaDisplay() {
    final mediaItem = audioHandler.musicPlayingState.currentMediaItem.value!;

    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.basePadding,
            vertical: AppConstants.basePadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Song Info"),
            AppConstants.basePadding.heightBox(),
            ...[
              ["Artist", mediaItem.artist ?? "-"],
              ["Album", mediaItem.album ?? "-"],
            ].map((each) {
              final label = each.first;
              final shownValue = each.last;
              return TextField(
                style: const TextStyle(fontSize: AppConstants.baseFontSizeM),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: label,
                    labelStyle:
                        const TextStyle(fontSize: AppConstants.baseFontSizeS),
                    fillColor: AppTheme.primaryBlack,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none),
                controller: TextEditingController(text: shownValue),
              );
            })
          ],
        ),
      ),
    );
  }
}
