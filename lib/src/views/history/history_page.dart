import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/models/music_model.dart';
import 'package:telemusic_v2/src/views/music_player/each_music_display_widget.dart';
import 'package:telemusic_v2/src/views/music_player/music_player_widget.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  ValueNotifier<bool> xLoading = ValueNotifier(false);
  List<MusicModel> allData = [];
  ApiRepo apiRepo = ApiRepo();

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

  initLoad() async {
    xLoading.value = true;
    await updateData();

    xLoading.value = false;
  }

  Future<void> updateData() async {
    allData.clear();
    try {
      final data = await apiRepo.getHistory();
      allData.addAll(data);
    } catch (e) {
      superPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: xLoading,
            builder: (context, xl, child) {
              if (xLoading.value) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else {
                if (allData.isEmpty) {
                  return const Center(
                    child: Text("No History Yet!"),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.only(
                        left: AppConstants.basePadding,
                        right: AppConstants.basePadding,
                        top: AppConstants.basePadding,
                        bottom: AppConstants.basePadding +
                            Get.mediaQuery.padding.bottom),
                    itemCount: allData.length,
                    itemBuilder: (context, index) {
                      final each = allData[index];
                      return EachMusicDisplayWidget(
                        musicModel: each,
                        serialNo: index + 1,
                        playList: allData,
                      );
                    },
                  );
                }
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
              child: const MusicPlayerWidget(),
            ),
          )
        ],
      ),
    );
  }
}
