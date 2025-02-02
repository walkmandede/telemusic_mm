import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/views/music_player/c_music_player_page_controller.dart';

class MyDependenciesInjector {
  Future<void> injectDependencies() async {
    Get.put(DataController());
    Get.put(MusicPlayerPageController());
  }
}
