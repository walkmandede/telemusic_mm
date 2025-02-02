import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemusic_v2/src/views/auth/auth_home_page.dart';
import 'package:telemusic_v2/src/views/discover/v_discover_page.dart';
import 'package:telemusic_v2/src/views/playlist/playlist_page.dart';
import 'package:telemusic_v2/src/views/premium/premium_page.dart';
import 'package:telemusic_v2/src/views/search/search_page.dart';
import 'package:telemusic_v2/utils/services/local_stroage/sp_keys.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';

enum EnumHomePageTab {
  discover(
      label: "Home",
      svg: AppSvgs.homeIcon,
      shownPage: DiscoverPage(),
      homePageTitle: "Home"),
  search(
      label: "Search",
      svg: AppSvgs.search,
      shownPage: SearchPage(),
      homePageTitle: "Search"),
  playlist(
      label: "Playlist",
      svg: AppSvgs.playlist,
      shownPage: PlaylistPage(),
      homePageTitle: "Your Playlists"),
  premium(
      label: "Premium",
      svg: AppSvgs.premium,
      shownPage: PremiumPage(),
      homePageTitle: "Premium"),
  ;

  final String label;
  final String svg;
  final Widget shownPage;
  final String homePageTitle;

  // Constructor for the enum
  const EnumHomePageTab(
      {required this.svg,
      required this.label,
      required this.shownPage,
      required this.homePageTitle});
}

class HomePageController extends GetxController
    with GetTickerProviderStateMixin {
  // late AnimationController pageTransitionAnimationController;
  ValueNotifier<EnumHomePageTab> selectedEnumHomePageTab =
      ValueNotifier(EnumHomePageTab.discover);

  @override
  void onInit() {
    _initLoad();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  _initLoad() async {
    // pageTransitionAnimationController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 250));
    // pageTransitionAnimationController.forward();
  }

  void changeTab({required EnumHomePageTab tab}) async {
    // await pageTransitionAnimationController.reverse();
    selectedEnumHomePageTab.value = tab;
    // await pageTransitionAnimationController.forward();
  }

  void toggleSideBar() {
    // try {
    //   if (scaffoldKey.currentState!.isDrawerOpen) {
    //     scaffoldKey.currentState!.openDrawer();
    //   } else {
    //     scaffoldKey.currentState!.closeDrawer();
    //   }
    // } catch (_) {}
  }

  Future<void> proceedLogOut() async {
    toggleSideBar();
    DialogService().showConfirmDialog(
      context: Get.context!,
      label: "Are you sure to log out?",
      onClickYes: () async {
        try {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          // await sharedPreferences.remove(SpKeys.email);
          await sharedPreferences.remove(SpKeys.password);
        } catch (_) {}
        await Get.offAll(() => const AuthHomePage());
      },
    );
  }
}
