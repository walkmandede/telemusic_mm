import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/models/album_model.dart';
import 'package:telemusic_v2/src/views/_common/image_placeholder_widget.dart';
import 'package:telemusic_v2/src/views/album/c_album_detail_page_controller.dart';
import 'package:telemusic_v2/src/views/album/widgets/w_actions_section.dart';
import 'package:telemusic_v2/src/views/album/widgets/w_music_section.dart';
import 'package:telemusic_v2/src/views/music_player/music_player_widget.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';

import '../../../utils/constants/app_constants.dart';

class AlbumDetailPage extends StatefulWidget {
  final AlbumModel albumModel;
  final EnumGetMusicTypes enumGetMusicTypes;
  const AlbumDetailPage(
      {super.key, required this.albumModel, required this.enumGetMusicTypes});

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  late AlbumDetailPageController albumDetailPageController;

  @override
  void initState() {
    albumDetailPageController = Get.put(AlbumDetailPageController());
    albumDetailPageController.initLoad(
        album: widget.albumModel, enumGetMusicTypes: widget.enumGetMusicTypes);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                  albumThumbnailWidget(),
                  ListView(
                    controller: albumDetailPageController.pageScrollController,
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
                    children: [
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bodyWidget() {
    return Padding(
      padding: EdgeInsets.only(top: Get.width),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppTheme.primaryBlack),
        child: ValueListenableBuilder(
          valueListenable: albumDetailPageController.xLoading,
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
                    const AlbumnDetailActionsSection(),
                    const AlbumDetailMusicSection(),
                    (Get.mediaQuery.padding.bottom).heightBox(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget backKeyWidget() {
    return ValueListenableBuilder(
        valueListenable: albumDetailPageController.pageScrolledValue,
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
                        widget.albumModel.name,
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

  Widget albumThumbnailWidget() {
    return ValueListenableBuilder(
      valueListenable: albumDetailPageController.pageScrolledValue,
      builder: (context, pageScrolledValue, child) {
        superPrint(widget.albumModel.image);
        return Stack(
          children: [
            Opacity(
              opacity: 1 - pageScrolledValue,
              child: Transform.scale(
                scale: 1 + pageScrolledValue * 0.25,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.albumModel.image,
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
