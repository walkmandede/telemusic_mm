import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/src/views/home/c_home_page_controller.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

class HomeSideBar extends StatelessWidget {
  const HomeSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    DataController dataController = Get.find();
    HomePageController homePageController = Get.find();
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack.withOpacity(0.8),
      body: SizedBox.expand(
        child: Row(
          children: [
            SizedBox(
              width: (Get.width / 3) * 2,
              height: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: AppTheme.primaryBlack.withOpacity(1),
                    border: Border(
                        right: BorderSide(
                            color: AppTheme.darkGray.withOpacity(0.3)))),
                child: Padding(
                  padding: AppConstants.getBaseScaffoldPadding(),
                  child: ValueListenableBuilder(
                      valueListenable: dataController.currentUser,
                      builder: (context, currentUser, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppTheme.primaryYellow,
                                  child: Text(currentUser == null
                                      ? "-"
                                      : currentUser.getNameInitials()),
                                ),
                                10.widthBox(),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentUser == null
                                            ? "-"
                                            : currentUser.name,
                                        style: const TextStyle(
                                            color: AppTheme.primaryYellow,
                                            fontSize:
                                                AppConstants.baseFontSizeXL,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        currentUser == null
                                            ? "-"
                                            : currentUser.email,
                                        style: const TextStyle(
                                            fontSize:
                                                AppConstants.baseFontSizeM,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            AppConstants.basePadding.heightBox(),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton.icon(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                    alignment: Alignment.centerLeft),
                                label: const Text(
                                  "Setting",
                                  style: TextStyle(color: AppTheme.lightGray),
                                ),
                                icon: SvgPicture.string(
                                  AppSvgs.setting,
                                  colorFilter: const ColorFilter.mode(
                                      AppTheme.lightGray, BlendMode.srcIn),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton.icon(
                                onPressed: () {
                                  vibrateNow();
                                  homePageController.proceedLogOut();
                                },
                                style: TextButton.styleFrom(
                                    alignment: Alignment.centerLeft),
                                label: const Text(
                                  "Log Out",
                                  style: TextStyle(color: AppTheme.lightGray),
                                ),
                                icon: SvgPicture.string(
                                  AppSvgs.logout,
                                  colorFilter: const ColorFilter.mode(
                                      AppTheme.lightGray, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                splashColor: Colors.transparent,
                child: const SizedBox.expand(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
