import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/src/views/home/c_home_page_controller.dart';
import 'package:telemusic_v2/src/views/home/widgets/home_app_bar.dart';
import 'package:telemusic_v2/src/views/home/widgets/home_navi_bar.dart';
import 'package:telemusic_v2/src/views/home/widgets/home_playing_widget.dart';
import 'package:telemusic_v2/src/views/home/widgets/home_side_bar.dart';
import 'package:telemusic_v2/src/views/music_player/music_player_widget.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:we_slide/we_slide.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageController homePageController;
  DataController dataController = Get.find();

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initLoad() async {
    log("initloaded");
    homePageController = Get.put(HomePageController());
    await dataController.updateUserInfo();
    await dataController.updateFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: homePageController.selectedEnumHomePageTab,
        builder: (context, selectedEnumHomePageTab, _) {
          return Scaffold(
            key: GlobalKey(),
            //todo remove appbar later
            appBar: getHomePageAppBar(),
            drawer: const HomeSideBar(),
            body: _shownPageSection(),
            bottomNavigationBar: const HomeNaviBar(),
          );
        });
  }

  Widget _shownPageSection() {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: homePageController.selectedEnumHomePageTab,
          builder: (context, selectedEnumHomePageTab, child) {
            return selectedEnumHomePageTab.shownPage;
            // return AnimatedBuilder(
            //   animation: homePageController.pageTransitionAnimationController,
            //   builder: (context, child) {
            //     final animatedValue =
            //         homePageController.pageTransitionAnimationController.value;
            //     return Opacity(
            //       opacity: animatedValue,
            //       child: selectedEnumHomePageTab.shownPage,
            //     );
            //   },
            // );
          },
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: AppConstants.basePadding),
            child: MusicPlayerWidget(),
          ),
        )
      ],
    );
  }
}
