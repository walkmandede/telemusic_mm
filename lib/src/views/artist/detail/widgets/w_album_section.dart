import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/views/_common/image_placeholder_widget.dart';
import 'package:telemusic_v2/src/views/album/album_detail_page.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../c_artist_detail_page_controller.dart';

class ArtistDetailAlbumSection extends StatelessWidget {
  const ArtistDetailAlbumSection({super.key});

  @override
  Widget build(BuildContext context) {
    ArtistDetailPageController artistDetailPageController = Get.find();

    if (artistDetailPageController.allAlbums.isEmpty) {
      return SizedBox(
        width: Get.width,
        child: const AspectRatio(
          aspectRatio: 4 / 3,
          child: Center(
            child: Text("No alubms for this artist yet!"),
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
              ...artistDetailPageController.allAlbums.map(
                (each) {
                  return ListTile(
                    onTap: () {
                      Get.to(() => AlbumDetailPage(
                          albumModel: each,
                          enumGetMusicTypes: EnumGetMusicTypes.albums));
                    },
                    contentPadding:
                        const EdgeInsets.only(left: 0, right: 0, bottom: 0),
                    title: Text(each.name),
                    subtitle: Text(each.artists.join(" • ")),
                    leading: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: each.image,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return const ImagePlaceholderWidget();
                        },
                      ),
                    ),
                  );
                },
              )
            ],
          )),
    );
  }
}
