import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/views/artist/detail/c_artist_detail_page_controller.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

class ArtistDetailTabBarWidget extends StatelessWidget {
  const ArtistDetailTabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ArtistDetailPageController artistDetailPageController = Get.find();
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.only(
            left: AppConstants.basePadding,
            top: AppConstants.basePadding / 4,
            bottom: AppConstants.basePadding * 0),
        child: ValueListenableBuilder(
          valueListenable: artistDetailPageController.selectedTab,
          builder: (context, selectedTab, child) {
            return Row(
              children: [
                ...EnumArtistDetailPageTab.values.map((each) {
                  final xSelected = selectedTab == each;
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: AppConstants.basePadding,
                        bottom: AppConstants.basePadding / 2),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            vibrateNow();
                            artistDetailPageController.changeTab(tab: each);
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text(
                            each.label,
                            style: TextStyle(
                                fontSize: AppConstants.baseFontSizeXL,
                                fontWeight: FontWeight.w600,
                                color: xSelected
                                    ? AppTheme.primaryYellow
                                    : AppTheme.lightGray),
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.15,
                          height: 3,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: xSelected
                                    ? AppTheme.primaryYellow
                                    : Colors.transparent),
                          ),
                        )
                      ],
                    ),
                  );
                })
              ],
            );
          },
        ),
      ),
    );
  }
}
