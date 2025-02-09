import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/audio_downloader.dart';
import 'package:telemusic_v2/src/views/download/c_download_page_controller.dart';
import 'package:telemusic_v2/src/views/music_player/music_player_widget.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  late DownloadPageController downloadPageController;

  @override
  void initState() {
    downloadPageController = Get.put(DownloadPageController());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Downloads"),
        centerTitle: false,
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: downloadPageController.xLoading,
              builder: (context, xLoading, child) {
                if (xLoading) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  final data = downloadPageController.downloadedMusics;
                  if (data.isEmpty) {
                    return const Center(
                      child: Text("There is no downloaded songs yet!"),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.only(
                        left: AppConstants.basePadding,
                        right: AppConstants.basePadding,
                        top: AppConstants.basePadding,
                        bottom: AppConstants.basePadding +
                            Get.mediaQuery.padding.bottom),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final eachData = data[index];
                      return ListTile(
                        onTap: () {
                          vibrateNow();
                          downloadPageController.proceedEachMusicClick(
                              musicDownloadModel: eachData);
                        },
                        title: Text(eachData.title),
                        subtitle: Text(eachData.artists),
                        trailing: IconButton(
                            onPressed: () {
                              DialogService().showConfirmDialog(
                                context: context,
                                label: "Are you sure?",
                                yesLabel: "Delete",
                                noLabel: "No",
                                onClickYes: () async {
                                  final result = await AudioDownloader
                                      .deleteDownloadedSong(eachData.id);
                                  downloadPageController.initLoad();
                                  superPrint(result);
                                },
                                onClickNo: () {},
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      );
                    },
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: AppConstants.basePadding +
                        Get.mediaQuery.padding.bottom),
                child: const MusicPlayerWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
