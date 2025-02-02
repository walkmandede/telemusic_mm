import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/views/album/c_album_detail_page_controller.dart';
import 'package:telemusic_v2/src/views/music_player/each_music_display_widget.dart';

import '../../../../../utils/constants/app_constants.dart';

class AlbumDetailMusicSection extends StatelessWidget {
  const AlbumDetailMusicSection({super.key});

  @override
  Widget build(BuildContext context) {
    AlbumDetailPageController albumDetailPageController = Get.find();

    if (albumDetailPageController.allMusics.isEmpty) {
      return SizedBox(
        width: Get.width,
        child: const AspectRatio(
          aspectRatio: 4 / 3,
          child: Center(
            child: Text("No musics in this album yet!"),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
          left: AppConstants.basePadding,
          right: AppConstants.basePadding,
          top: AppConstants.basePadding),
      child: SizedBox(
          width: Get.width,
          child: Column(
            children: [
              ...albumDetailPageController.allMusics.map(
                (each) {
                  return EachMusicDisplayWidget(
                      musicModel: each,
                      serialNo:
                          albumDetailPageController.allMusics.indexOf(each) +
                              1);
                },
              )
            ],
          )),
    );
  }
}
