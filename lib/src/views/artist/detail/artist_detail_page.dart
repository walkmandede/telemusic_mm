import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/models/artist_model.dart';
import 'package:telemusic_v2/src/views/_common/image_placeholder_widget.dart';
import 'package:telemusic_v2/src/views/artist/detail/c_artist_detail_page_controller.dart';
import 'package:telemusic_v2/src/views/artist/detail/widgets/w_actions_section.dart';
import 'package:telemusic_v2/src/views/artist/detail/widgets/w_stream_count_section.dart';
import 'package:telemusic_v2/src/views/artist/detail/widgets/w_tab_bar_widget.dart';
import 'package:telemusic_v2/src/views/music_player/c_music_player_page_controller.dart';
import 'package:telemusic_v2/src/views/music_player/music_player_widget.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

class ArtistDetailPage extends StatefulWidget {
  final ArtistModel artistModel;
  const ArtistDetailPage({super.key, required this.artistModel});

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  late ArtistDetailPageController artistDetailPageController;
  MusicPlayerPageController musicPlayerPageController = Get.find();

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _initLoad() async {
    artistDetailPageController = Get.put(ArtistDetailPageController());
    artistDetailPageController.initLoad(artistModel: widget.artistModel);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: audioHandler.musicPlayingState.currentMediaItem,
      builder: (context, currentMediaItem, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            body: SizedBox.expand(
              child: Stack(
                children: [
                  artistThumbnailWidget(),
                  ListView(
                    controller: artistDetailPageController.pageScrollController,
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      IgnorePointer(
                        ignoring: true,
                        child: (Get.width).heightBox(),
                      ),
                      bodyWidget(),
                    ],
                  ),
                  backKeyWidget(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: Get.mediaQuery.padding.bottom),
                      child: const MusicPlayerWidget(),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bodyWidget() {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppTheme.primaryBlack),
      child: ValueListenableBuilder(
        valueListenable: artistDetailPageController.xLoading,
        builder: (context, xLoading, child) {
          if (xLoading) {
            return SizedBox(
              width: Get.width,
              height: Get.height - Get.width,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          } else {
            return SizedBox(
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.artistModel.enumStreamChannelCountMap.isNotEmpty)
                    const ArtistDetailStreamCountSection(),
                  const ArtistDetailActionsSection(),
                  const ArtistDetailTabBarWidget(),
                  ValueListenableBuilder(
                    valueListenable: artistDetailPageController.selectedTab,
                    builder: (context, selectedTab, child) {
                      return selectedTab.shownWidget;
                    },
                  ),
                  (Get.mediaQuery.padding.bottom).heightBox(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget backKeyWidget() {
    return ValueListenableBuilder(
        valueListenable: artistDetailPageController.pageScrolledValue,
        builder: (context, pageScrolledValue, child) {
          bool xCollesped = pageScrolledValue >= 0.8;
          return DecoratedBox(
            decoration: BoxDecoration(
                color: xCollesped ? AppTheme.primaryBlack : Colors.transparent),
            child: Padding(
              padding: EdgeInsets.only(
                  left: AppConstants.basePadding / 2,
                  top: Get.mediaQuery.padding.top),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryBlack.withOpacity(0.6),
                    child: const BackButton(
                      color: AppTheme.white,
                    ),
                  ),
                  AppConstants.basePadding.widthBox(),
                  Builder(
                    builder: (context) {
                      if (pageScrolledValue < 1) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        widget.artistModel.artistName,
                        style: const TextStyle(
                            color: AppTheme.white,
                            fontWeight: FontWeight.bold,
                            fontSize: AppConstants.baseFontSizeL),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget artistThumbnailWidget() {
    return ValueListenableBuilder(
      valueListenable: artistDetailPageController.pageScrolledValue,
      builder: (context, pageScrolledValue, child) {
        return Stack(
          children: [
            Opacity(
              opacity: 1 - pageScrolledValue,
              child: Transform.scale(
                scale: 1 + pageScrolledValue * 0.25,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.artistModel.image,
                      width: Get.width,
                      height: Get.width,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return const ImagePlaceholderWidget();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: Get.width * (1 - pageScrolledValue),
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                Colors.transparent,
                AppTheme.primaryBlack.withOpacity(0.9 * pageScrolledValue)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
            ),
          ],
        );
      },
    );
  }
}
