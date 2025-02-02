import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/models/album_model.dart';
import 'package:telemusic_v2/src/models/music_model.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';

class AlbumDetailPageController extends GetxController {
  ValueNotifier<bool> xLoading = ValueNotifier(false);
  List<MusicModel> allMusics = [];
  ApiRepo apiRepo = ApiRepo();
  late AlbumModel albumModel;
  ScrollController pageScrollController = ScrollController();
  ValueNotifier<double> pageScrolledValue = ValueNotifier(0); // 0 - 1

  Future<void> initLoad(
      {required AlbumModel album,
      required EnumGetMusicTypes enumGetMusicTypes}) async {
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
    albumModel = album;
    xLoading.value = true;
    try {
      allMusics = await apiRepo.getMusicByCategory(
              id: album.id.toString(), type: enumGetMusicTypes.label) ??
          [];
    } catch (e) {
      superPrint(e);
    }
    xLoading.value = false;
  }

  Future<void> proceedOnClickPlayButton(
      {required MusicModel musicModel}) async {
    await audioHandler.playAllSongs(
        songs: [musicModel.convertToMediaItem()], xNetworkSong: true);
  }
}
