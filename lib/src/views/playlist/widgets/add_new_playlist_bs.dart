import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/views/playlist/c_playlist_page_controller.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

class AddNewPlaylistBottomSheet extends StatefulWidget {
  const AddNewPlaylistBottomSheet({super.key});

  @override
  State<AddNewPlaylistBottomSheet> createState() =>
      _AddNewPlaylistBottomSheetState();
}

class _AddNewPlaylistBottomSheetState extends State<AddNewPlaylistBottomSheet> {
  TextEditingController txtPlaylistName = TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> onClickCreateNewPlaylist() async {
    if (txtPlaylistName.text.isEmpty) {
      DialogService().showConfirmDialog(
          context: context, label: "Playlist name should not be empty!");
    } else {
      DialogService().showLoadingDialog(context: context);

      final result =
          await ApiRepo().createAPlaylist(name: txtPlaylistName.text);
      superPrint(result);
      DialogService().dismissDialog(context: Get.context!);
      if (result.xSuccess) {
        //todo refresh list
        Get.back();
        PlaylistPageController playlistPageController = Get.find();
        playlistPageController.initLoad();
      } else {
        DialogService()
            .showConfirmDialog(context: Get.context!, label: result.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: DecoratedBox(
        decoration: const BoxDecoration(
            color: AppTheme.primaryBlack,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppConstants.baseBorderRadius))),
        child: Padding(
          padding: EdgeInsets.only(
              left: AppConstants.basePadding,
              right: AppConstants.basePadding,
              top: AppConstants.basePadding,
              bottom: AppConstants.basePadding + Get.mediaQuery.padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter your playlist name",
                style: TextStyle(
                    fontSize: AppConstants.baseFontSizeXL,
                    color: AppTheme.white,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.basePadding),
                child: TextField(
                  controller: txtPlaylistName,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    vibrateNow();
                    onClickCreateNewPlaylist();
                  },
                  child: const Text("Create playlist"))
            ],
          ),
        ),
      ),
    );
  }
}
