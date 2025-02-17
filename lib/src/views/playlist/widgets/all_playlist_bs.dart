import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/models/music_model.dart';
import 'package:telemusic_v2/src/models/playlist_model.dart';
import 'package:telemusic_v2/src/views/playlist/c_playlist_page_controller.dart';
import 'package:telemusic_v2/src/views/playlist/widgets/add_new_playlist_bs.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

class AllPlaylistBottomSheet extends StatefulWidget {
  final MusicModel musicModel;
  const AllPlaylistBottomSheet({super.key, required this.musicModel});

  @override
  State<AllPlaylistBottomSheet> createState() => _AllPlaylistBottomSheetState();
}

class _AllPlaylistBottomSheetState extends State<AllPlaylistBottomSheet> {
  ValueNotifier<bool> xLoading = ValueNotifier(false);
  ApiRepo apiRepo = ApiRepo();
  List<PlaylistModel> allPlaylists = [];

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> initLoad() async {
    allPlaylists.clear();
    xLoading.value = true;
    try {
      final result = await apiRepo.getAllPlaylists();
      final imagePath = result.bodyData["imagePath"] ?? "";
      final audioPath = result.bodyData["audioPath"] ?? "";
      Iterable iterable = result.bodyData["data"];
      for (final each in iterable) {
        final playlist = PlaylistModel.fromJson(
            json: each, imagePath: imagePath, audioPath: audioPath);
        allPlaylists.add(playlist);
      }
    } catch (e) {
      superPrint(e);
    }
    xLoading.value = false;
  }

  Future<void> onClickAddMusic({required PlaylistModel playlist}) async {
    DialogService().showLoadingDialog(context: context);

    final result = await ApiRepo().addMusicToPlayList(
        musicId: widget.musicModel.id.toString(),
        playlistId: playlist.id.toString());
    superPrint(result);
    DialogService().dismissDialog(context: Get.context!);
    if (result.xSuccess) {
      //todo refresh list
      Get.back();
      PlaylistPageController playlistPageController = Get.find();
      playlistPageController.initLoad();
      DialogService()
          .showConfirmDialog(context: Get.context!, label: result.message);
    } else {
      DialogService()
          .showConfirmDialog(context: Get.context!, label: result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor:
          0.8, // Set the height of the bottom sheet as a fraction of the screen
      child: SizedBox(
        width: Get.width,
        child: DecoratedBox(
          decoration: const BoxDecoration(
              color: AppTheme.primaryBlack,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppConstants.baseBorderRadius))),
          child: Padding(
            padding: EdgeInsets.only(
              left: AppConstants.basePadding,
              right: AppConstants.basePadding,
              top: AppConstants.basePadding,
              bottom: AppConstants.basePadding + Get.mediaQuery.padding.bottom,
            ),
            child: SingleChildScrollView(
              // Add scrollable container
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Click the playlist to add",
                    style: TextStyle(
                        fontSize: AppConstants.baseFontSizeM,
                        color: AppTheme.darkGray,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.musicModel.audioTitle,
                    style: const TextStyle(
                        fontSize: AppConstants.baseFontSizeL,
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ValueListenableBuilder(
                    valueListenable: xLoading,
                    builder: (context, xLoading, child) {
                      if (xLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(AppConstants.basePadding),
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        );
                      } else {
                        if (allPlaylists.isEmpty) {
                          return Center(
                            child: TextButton(
                                onPressed: () {
                                  Get.back();
                                  Get.bottomSheet(
                                      const AddNewPlaylistBottomSheet());
                                },
                                child: const Text(
                                    "No playlist Yet!\nClick here to create one")),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: allPlaylists.length,
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(), // Prevent scrolling inside the ListView
                          itemBuilder: (context, index) {
                            final playList = allPlaylists[index];
                            return ListTile(
                              onTap: () {
                                vibrateNow();
                                onClickAddMusic(playlist: playList);
                              },
                              contentPadding: EdgeInsets.zero,
                              title: Text(playList.playlistName),
                              subtitle:
                                  Text("${playList.songList.length} Songs"),
                            );
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
