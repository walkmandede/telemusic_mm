import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/models/music_model.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';

class SearchPageController extends GetxController {
  ValueNotifier<bool> xFetching = ValueNotifier(false);
  TextEditingController txtSearch = TextEditingController(text: "");
  List<MusicModel> shownData = [];
  Timer? timer;
  ApiRepo apiRepo = ApiRepo();

  @override
  void onInit() {
    initLoad();
    super.onInit();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  initLoad() async {
    timer = Timer(
      const Duration(milliseconds: 1500),
      () {},
    );

    searchData();
  }

  void resetTimer() {
    if (timer == null) {
      timer = Timer(
        const Duration(milliseconds: 750),
        () {
          searchData();
        },
      );
    } else {
      timer!.cancel();
      timer = Timer(
        const Duration(milliseconds: 750),
        () {
          searchData();
        },
      );
    }
  }

  Future<void> searchData() async {
    if (!xFetching.value) {
      xFetching.value = true;
      try {
        final query = txtSearch.text;
        shownData = await apiRepo.searchMusicsByQuery(query: query) ?? [];
      } catch (e) {
        superPrint(e);
      }
      xFetching.value = false;
    }
  }
}
