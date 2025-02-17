import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/models/plan_model.dart';
import 'package:telemusic_v2/src/views/premium/premium_detail_page.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  ValueNotifier<bool> xLoading = ValueNotifier(false);
  List<PlanModel> allPlans = List.empty();

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  initLoad() async {
    xLoading.value = true;
    try {
      allPlans = await ApiRepo().getAllPlans();
    } catch (e) {
      superPrint(e);
    }
    xLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.basePadding,
            vertical: AppConstants.basePadding),
        child: ValueListenableBuilder(
          valueListenable: xLoading,
          builder: (context, xLoading, child) {
            if (xLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (allPlans.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: AppConstants.basePadding),
                    child: Text("There are no plan available yet."),
                  ),
                if (allPlans.isNotEmpty)
                  ...allPlans.map((each) {
                    return InkWell(
                      onTap: () {
                        vibrateNow();
                        Get.to(() => PremiumDetailPage(planModel: each));
                      },
                      child: AspectRatio(
                        aspectRatio: 2,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppConstants.baseBorderRadius)),
                          child: Stack(
                            children: [
                              // CachedNetworkImage(
                              //   imageUrl: each.image,
                              //   width: double.infinity,
                              //   height: double.infinity,
                              //   fit: BoxFit.cover,
                              // ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppConstants.basePadding,
                                    vertical: AppConstants.basePadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.string(
                                          AppSvgs.premium,
                                          colorFilter: const ColorFilter.mode(
                                              AppTheme.white, BlendMode.srcIn),
                                        ),
                                        (10.widthBox()),
                                        const Text(
                                          "Premium",
                                          style:
                                              TextStyle(color: AppTheme.white),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      each.planName,
                                      style: const TextStyle(
                                          color: AppTheme.primaryYellow,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              AppConstants.baseFontSizeXL),
                                    ),
                                    Text(
                                      "- Plan amount : ${each.planAmount} \$\n"
                                      "- Duration : ${each.validity} ${each.isMonthDays == 0 ? "Days" : "Months"}",
                                      style: const TextStyle(
                                          color: AppTheme.lightGray,
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppConstants.baseFontSizeM),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
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
