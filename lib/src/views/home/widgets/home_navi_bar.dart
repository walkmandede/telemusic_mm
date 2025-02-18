import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/src/views/home/c_home_page_controller.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';

import '../../../../utils/constants/app_theme.dart';

class HomeNaviBar extends StatelessWidget {
  const HomeNaviBar({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageController homePageController = Get.find();
    DataController dataController = Get.find();
    return ValueListenableBuilder(
      valueListenable: homePageController.selectedEnumHomePageTab,
      builder: (context, selectedEnumHomePageTab, child) {
        return BottomNavigationBar(
          elevation: 10,
          backgroundColor: AppTheme.primaryBlack,
          enableFeedback: true,
          type: BottomNavigationBarType.fixed,
          fixedColor: AppTheme.primaryYellow,
          showSelectedLabels: true,
          // selectedItemColor: AppTheme.primaryYellow,
          currentIndex: EnumHomePageTab.values.indexOf(selectedEnumHomePageTab),
          onTap: (value) {
            vibrateNow();
            homePageController.changeTab(tab: EnumHomePageTab.values[value]);
          },
          showUnselectedLabels: true,
          items: List.generate(EnumHomePageTab.values.length, (index) {
            final each = EnumHomePageTab.values[index];
            bool xSelected = selectedEnumHomePageTab == each;
            final icon = SvgPicture.string(
              each.svg,
              colorFilter: ColorFilter.mode(
                  xSelected ? AppTheme.primaryYellow : AppTheme.darkGray,
                  BlendMode.srcIn),
            );
            return BottomNavigationBarItem(
                backgroundColor: AppTheme.primaryBlack,
                icon: icon,
                activeIcon: icon,
                label: each.label);
          }),
        );
      },
    );
  }
}
