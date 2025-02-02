import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/models/music_model.dart';

class MusicPlayerPageController extends GetxController {
  double playingWidgetHeight = Get.height * 0.075;
  // double playingPageHeight = Get.height - (Get.mediaQuery.padding.top);

  @override
  void onInit() {
    _initLoad();
    super.onInit();
  }

  @override
  void onClose() {
    //
    super.onClose();
  }

  _initLoad() async {}

  Future<void> proceedOnClickPlayButton(
      {required MusicModel musicModel}) async {
    await audioHandler.playAllSongs(
        songs: [musicModel.convertToMediaItem()], xNetworkSong: true);
  }
}
