import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/views/music_player/each_music_display_widget.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../c_artist_detail_page_controller.dart';

class ArtistDetailMusicSection extends StatelessWidget {
  const ArtistDetailMusicSection({super.key});

  @override
  Widget build(BuildContext context) {
    ArtistDetailPageController artistDetailPageController = Get.find();

    if (artistDetailPageController.allMusics.isEmpty) {
      return SizedBox(
        width: Get.width,
        child: const AspectRatio(
          aspectRatio: 4 / 3,
          child: Center(
            child: Text("No musics for this artist yet!"),
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
              ...artistDetailPageController.allMusics.map(
                (each) {
                  return EachMusicDisplayWidget(
                      musicModel: each,
                      playList: artistDetailPageController.allMusics,
                      serialNo:
                          artistDetailPageController.allMusics.indexOf(each) +
                              1);
                },
              )
            ],
          )),
    );
  }
}
