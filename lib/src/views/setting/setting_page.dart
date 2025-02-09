import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/src/views/auth/auth_home_page.dart';
import 'package:telemusic_v2/src/views/blogs/blogs_page.dart';
import 'package:telemusic_v2/src/views/download/download_page.dart';
import 'package:telemusic_v2/src/views/favorites/favorite_page.dart';
import 'package:telemusic_v2/src/views/history/history_page.dart';
import 'package:telemusic_v2/src/views/home/c_home_page_controller.dart';
import 'package:telemusic_v2/src/views/music_player/each_music_display_widget.dart';
import 'package:telemusic_v2/src/views/others/privacy_policy_page.dart';
import 'package:telemusic_v2/src/views/others/tnc_page.dart';
import 'package:telemusic_v2/src/views/payment/payment_page.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  DataController dataController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: false,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.only(
              left: AppConstants.basePadding,
              right: AppConstants.basePadding,
              top: AppConstants.basePadding,
              bottom: Get.mediaQuery.padding.bottom),
          child: Column(
            // shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            // padding: EdgeInsets.only(
            //     left: AppConstants.basePadding,
            //     right: AppConstants.basePadding,
            //     top: AppConstants.basePadding,
            //     bottom: AppConstants.basePadding + Get.mediaQuery.padding.bottom),
            children: [
              profileWidget(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      onTap: () {
                        vibrateNow();
                        Get.to(() => const BlogsPage());
                      },
                      title: const Text("Blogs"),
                    ),
                    ListTile(
                      onTap: () {
                        vibrateNow();
                        Get.to(() => const FavoritePage());
                      },
                      title: const Text("Favorites"),
                    ),
                    ListTile(
                      onTap: () {
                        vibrateNow();
                        Get.to(() => const HistoryPage());
                      },
                      title: const Text("History"),
                    ),
                    ListTile(
                      onTap: () {
                        vibrateNow();
                        Get.to(() => const DownloadPage());
                      },
                      title: const Text("Downloads"),
                    ),
                    ListTile(
                      onTap: () {
                        vibrateNow();
                        Get.to(() => const TncPage());
                      },
                      title: const Text("Terms & Conditions"),
                    ),
                    ListTile(
                      onTap: () {
                        vibrateNow();
                        Get.to(() => const PrivacyPolicyPage());
                      },
                      title: const Text("Privacy Policy"),
                    ),
                    ValueListenableBuilder(
                      valueListenable: dataController.currentUser,
                      builder: (context, currentUser, child) {
                        if (currentUser == null) {
                          return const SizedBox.shrink();
                        } else {
                          if (currentUser.xShouldShowPayment()) {
                            return ListTile(
                              onTap: () {
                                vibrateNow();
                                Get.to(() => const PaymentPage());
                              },
                              title: const Text("Payment Methods"),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }
                      },
                    ),
                    ListTile(
                      onTap: () {
                        vibrateNow();
                        DialogService().showConfirmDialog(
                          context: context,
                          label: "Are you sure to delete?",
                          yesLabel: "Delete",
                          noLabel: "No",
                          onClickYes: () async {
                            final apiResponse = await ApiRepo().deleteAccount();
                            if (apiResponse.xSuccess) {
                              Get.off(() => const AuthHomePage());
                            }
                          },
                          onClickNo: () {},
                        );
                      },
                      title: Text(
                        "Delete Account",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  vibrateNow();
                  HomePageController homePageController = Get.find();
                  homePageController.proceedLogOut();
                },
                leading: SvgPicture.string(
                  AppSvgs.logout,
                  colorFilter:
                      const ColorFilter.mode(AppTheme.white, BlendMode.srcIn),
                ),
                title: const Text("Log Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

profileWidget() {
  DataController dataController = Get.find();
  return ValueListenableBuilder(
    valueListenable: dataController.currentUser,
    builder: (context, currentUser, child) {
      if (currentUser == null) {
        return const SizedBox.shrink();
      } else {
        final radius = Get.width * 0.075;
        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: radius * 2,
                  child: CircleAvatar(
                    radius: radius,
                    child: Text(currentUser.getNameInitials()),
                  ),
                ),
                AppConstants.basePadding.widthBox(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser.name,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: AppConstants.baseFontSizeXL,
                          color: AppTheme.white),
                    ),
                    Text(
                      currentUser.email,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: AppConstants.baseFontSizeM,
                          color: AppTheme.lightGray),
                    ),
                    Text(
                      "version - ${dataController.appVersion}",
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: AppConstants.baseFontSizeS,
                          color: AppTheme.darkGray),
                    ),
                  ],
                )
              ],
            ),
            const Padding(
                padding:
                    EdgeInsets.symmetric(vertical: AppConstants.basePadding),
                child: Divider()),
          ],
        );
      }
    },
  );
}
