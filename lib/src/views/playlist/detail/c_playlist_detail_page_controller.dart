import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/models/album_model.dart';
import 'package:telemusic_v2/src/models/music_model.dart';
import 'package:telemusic_v2/src/models/playlist_model.dart';
import 'package:telemusic_v2/src/views/playlist/c_playlist_page_controller.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

class PlaylistDetailPageController extends GetxController {
  ValueNotifier<bool> xLoading = ValueNotifier(false);

  ApiRepo apiRepo = ApiRepo();
  late PlaylistModel playlistModel;
  ScrollController pageScrollController = ScrollController();
  ValueNotifier<double> pageScrolledValue = ValueNotifier(0); // 0 - 1

  Future<void> initLoad({required PlaylistModel playlist}) async {
    xLoading.value = true;

    pageScrollController.addListener(
      () {
        final scrolledAmount = pageScrollController.position.pixels;
        if (scrolledAmount <= 0) {
          pageScrolledValue.value = 0;
        } else if (scrolledAmount >= Get.width) {
          pageScrolledValue.value = 1;
        } else {
          pageScrolledValue.value = scrolledAmount / Get.width;
        }
      },
    );
    playlistModel = playlist;
    xLoading.value = false;
  }

  Future<void> proceedOnClickPlayButton(
      {required MusicModel musicModel}) async {
    await audioHandler.playAllSongs(
        songs: [musicModel.convertToMediaItem()], xNetworkSong: true);
  }

  Future<void> removeFromPlaylist({required MusicModel musicModel}) async {
    DialogService().showLoadingDialog(context: Get.context!);
    final result = await ApiRepo().removeMusicFromPlaylist(
        musicId: musicModel.id.toString(),
        playlistId: playlistModel.id.toString());
    superPrint(result);
    DialogService().dismissDialog(context: Get.context!);
    if (result.xSuccess) {
      //todo refresh list
      xLoading.value = true;
      PlaylistPageController playlistPageController = Get.find();
      playlistPageController.initLoad();
      playlistModel.songList.remove(musicModel);
      xLoading.value = false;

      DialogService()
          .showConfirmDialog(context: Get.context!, label: result.message);
    } else {
      DialogService()
          .showConfirmDialog(context: Get.context!, label: result.message);
    }
  }

  void deletePlaylist() async {
    DialogService().showLoadingDialog(context: Get.context!);
    final result =
        await ApiRepo().deletePlaylist(playlistId: playlistModel.id.toString());
    superPrint(result);
    DialogService().dismissDialog(context: Get.context!);
    if (result.xSuccess) {
      //todo refresh list
      PlaylistPageController playlistPageController = Get.find();
      playlistPageController.initLoad();
      Get.back();
    } else {
      DialogService()
          .showConfirmDialog(context: Get.context!, label: result.message);
    }
  }
}
