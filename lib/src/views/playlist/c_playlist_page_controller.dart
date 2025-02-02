import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/models/playlist_model.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';

class PlaylistPageController extends GetxController {
  ValueNotifier<bool> xLoading = ValueNotifier(false);
  List<PlaylistModel> allPlaylists = [];
  ApiRepo apiRepo = ApiRepo();

  @override
  void onInit() {
    initLoad();
    super.onInit();
  }

  @override
  void onClose() {
    //
    super.onClose();
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
}
