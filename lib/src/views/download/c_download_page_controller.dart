import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/models/music_download_model.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/local_stroage/sp_keys.dart';

class DownloadPageController extends GetxController {
  ValueNotifier<bool> xLoading = ValueNotifier(false);
  List<MusicDownloadModel> downloadedMusics = [];

  @override
  void onInit() {
    initLoad();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> initLoad() async {
    xLoading.value = true;
    downloadedMusics.clear();
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final rawList =
          sharedPreferences.getStringList(SpKeys.downloadedMusic) ?? [];
      superPrint(rawList);
      for (final each in rawList) {
        downloadedMusics.add(MusicDownloadModel.fromJson(jsonString: each));
      }
    } catch (e) {
      superPrint(e);
    }
    xLoading.value = false;
  }

  void proceedEachMusicClick(
      {required MusicDownloadModel musicDownloadModel}) async {
    await audioHandler.playAllSongs(
        songs: [...downloadedMusics.map((e) => e.convertToMediaItem())],
        index: downloadedMusics.indexOf(musicDownloadModel),
        xNetworkSong: false);
    // await audioHandler.playDesiredSong(
    //     mediaItem: musicDownloadModel.convertToMediaItem(),
    //     xNetworkSong: false);
  }
}
