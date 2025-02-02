import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/src/views/home/c_home_page_controller.dart';
import 'package:telemusic_v2/src/views/playlist/widgets/add_new_playlist_bs.dart';
import 'package:telemusic_v2/src/views/setting/setting_page.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

PreferredSizeWidget? getHomePageAppBar() {
  HomePageController homePageController = Get.find();
  DataController dataController = Get.find();
  final currentTab = homePageController.selectedEnumHomePageTab.value;
  return AppBar(
    // leading: const SizedBox.shrink(),
    centerTitle: false,
    // leadingWidth: 0,
    leading: Padding(
      padding: const EdgeInsets.only(left: AppConstants.basePadding),
      child: ValueListenableBuilder(
        valueListenable: dataController.currentUser,
        builder: (context, currentUser, child) {
          if (currentUser == null) {
            return const SizedBox.shrink();
          }
          return InkWell(
            onTap: () {
              Get.to(() => const SettingPage());
            },
            child: CircleAvatar(
              backgroundColor: AppTheme.primaryYellow,
              child: Text(currentUser.getNameInitials()),
            ),
          );
        },
      ),
    ),
    title: Text(currentTab.homePageTitle),
    actions: [
      if (currentTab == EnumHomePageTab.playlist)
        IconButton(
            onPressed: () {
              Get.bottomSheet(const AddNewPlaylistBottomSheet());
            },
            icon: SvgPicture.string(
              AppSvgs.addNewPlaylist,
              colorFilter:
                  const ColorFilter.mode(AppTheme.white, BlendMode.srcIn),
            ))
    ],
  );
}
