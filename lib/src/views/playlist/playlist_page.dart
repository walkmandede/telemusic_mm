import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/views/_common/image_placeholder_widget.dart';
import 'package:telemusic_v2/src/views/playlist/c_playlist_page_controller.dart';
import 'package:telemusic_v2/src/views/playlist/detail/playlist_detail_page.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late PlaylistPageController playlistPageController;

  @override
  void initState() {
    playlistPageController = Get.put(PlaylistPageController());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.only(
            left: AppConstants.basePadding, right: AppConstants.basePadding),
        child: ValueListenableBuilder(
          valueListenable: playlistPageController.xLoading,
          builder: (context, xLoading, child) {
            if (xLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              final playlists = playlistPageController.allPlaylists;
              if (playlists.isEmpty) {
                return const Center(
                  child: Text("No playlist yet, create a new playlist."),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(
                    left: 0, top: AppConstants.basePadding),
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return ListTile(
                    onTap: () {
                      vibrateNow();
                      Get.to(() => PlaylistDetailPage(playlist: playlist));
                    },
                    contentPadding:
                        const EdgeInsets.only(bottom: AppConstants.basePadding),
                    leading: AspectRatio(
                      aspectRatio: 1,
                      child: playlist.getCoverImage() ??
                          SvgPicture.string(
                            AppSvgs.playlist,
                            colorFilter: const ColorFilter.mode(
                                AppTheme.white, BlendMode.srcIn),
                          ),
                    ),
                    title: Text(playlist.playlistName),
                    subtitle: Text("${playlist.songList.length} Songs"),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
