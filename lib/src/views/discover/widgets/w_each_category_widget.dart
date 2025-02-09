import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/models/category_model.dart';
import 'package:telemusic_v2/src/models/sub_category_model.dart';
import 'package:telemusic_v2/src/views/_common/image_placeholder_widget.dart';
import 'package:telemusic_v2/src/views/category_list/category_list_page.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

class EachCategoryWidget extends StatelessWidget {
  final CategoryModel eachCategory;
  final Function(SubCategoryModel subCategory, CategoryModel category)
      onClickEach;
  const EachCategoryWidget(
      {super.key, required this.eachCategory, required this.onClickEach});

  @override
  Widget build(BuildContext context) {
    final trimmed =
        eachCategory.categoryName.trim().toLowerCase().replaceAll(" ", "");
    bool xArtists = trimmed.contains("artist");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.basePadding,
              vertical: AppConstants.basePadding / 2),
          child: Row(
            children: [
              Text(
                eachCategory.categoryName,
                style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: AppConstants.baseFontSizeXL,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  vibrateNow();
                  Get.to(() => CategoryListPage(categoryModel: eachCategory));
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  "View all",
                  style: TextStyle(color: AppTheme.primaryYellow),
                ),
              )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              //myArr.length > 5 ? myArr.sublist(myArr.length - 5) : myArr
              //eachCategory.subCategories
              (AppConstants.basePadding).widthBox(),
              ...(eachCategory.subCategories.length > 10
                      ? eachCategory.subCategories
                          .sublist(eachCategory.subCategories.length - 10)
                      : eachCategory.subCategories)
                  .map(
                (eachSubCategory) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        right: AppConstants.basePadding / 2),
                    child: GestureDetector(
                      onTap: () {
                        vibrateNow();
                        onClickEach(eachSubCategory, eachCategory);
                      },
                      child: SizedBox(
                        width: Get.width * 0.4,
                        child: Column(
                          crossAxisAlignment: xArtists
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 10,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      xArtists ? 1000000 : 0)),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      xArtists ? 1000000 : 0),
                                  child: CachedNetworkImage(
                                    imageUrl: eachSubCategory.image,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) {
                                      return const ImagePlaceholderWidget();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            (AppConstants.basePadding * 0.5).heightBox(),
                            Text(
                              eachSubCategory.name,
                              maxLines: 2,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).toList()
            ],
          ),
        ),
      ],
    );
  }
}
