import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/models/album_model.dart';
import 'package:telemusic_v2/src/models/artist_model.dart';
import 'package:telemusic_v2/src/models/category_model.dart';
import 'package:telemusic_v2/src/views/album/album_detail_page.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';

import '../artist/detail/artist_detail_page.dart';

class CategoryListPage extends StatefulWidget {
  final CategoryModel categoryModel;
  const CategoryListPage({super.key, required this.categoryModel});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.categoryModel.categoryName),
      ),
      body: SizedBox.expand(
        child: widget.categoryModel.subCategories.isEmpty
            ? const Center(
                child: Text("No music yet!"),
              )
            : GridView.builder(
                padding: EdgeInsets.only(
                  left: AppConstants.basePadding,
                  right: AppConstants.basePadding,
                  top: AppConstants.basePadding,
                  bottom:
                      AppConstants.basePadding + Get.mediaQuery.padding.bottom,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / 1.2,
                ),
                itemCount: widget.categoryModel.subCategories.length,
                itemBuilder: (context, index) {
                  final subCategory = widget.categoryModel.subCategories[index];
                  return GestureDetector(
                    onTap: () {
                      final trimmed = widget.categoryModel.categoryName
                          .trim()
                          .toLowerCase()
                          .replaceAll(" ", "");

                      if (trimmed.contains("album")) {
                        Get.to(() => AlbumDetailPage(
                              albumModel: AlbumModel(
                                  id: subCategory.id,
                                  name: subCategory.name,
                                  slug: subCategory.slug,
                                  image: subCategory.image,
                                  isFeatured: subCategory.isFeatured,
                                  isTrending: subCategory.isTrending,
                                  isRecommended: subCategory.isRecommended,
                                  artistIds: const [],
                                  artists: const []),
                              enumGetMusicTypes: EnumGetMusicTypes.albums,
                            ));
                      } else if (trimmed.contains("genres")) {
                        Get.to(() => AlbumDetailPage(
                              albumModel: AlbumModel(
                                  id: subCategory.id,
                                  name: subCategory.name,
                                  slug: subCategory.slug,
                                  image: subCategory.image,
                                  isFeatured: subCategory.isFeatured,
                                  isTrending: subCategory.isTrending,
                                  isRecommended: subCategory.isRecommended,
                                  artistIds: const [],
                                  artists: const []),
                              enumGetMusicTypes: EnumGetMusicTypes.genres,
                            ));
                      } else if (trimmed.contains("artist")) {
                        Get.to(() => ArtistDetailPage(
                            artistModel: ArtistModel(
                                image: subCategory.image,
                                artistName: subCategory.name,
                                id: subCategory.id,
                                artistSlug: subCategory.slug,
                                isFeatured: subCategory.isFeatured,
                                isTrending: subCategory.isTrending,
                                isRecommended: subCategory.isRecommended,
                                artistGenreId: "",
                                audioLanguageIds: const [],
                                createdAt: "",
                                customOrder: 0,
                                listeningCount: 0,
                                paymentHolderName: "",
                                paymentType: "",
                                paymentValue: "",
                                status: 0,
                                totalPaymentValue: '',
                                updatedAt: "",
                                userId: "",
                                description: "",
                                enumStreamChannelCountMap:
                                    subCategory.streamCounts,
                                dob: "")));
                      } else if (trimmed.contains("genre")) {
                        superPrint("Genre");
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppConstants.baseBorderRadius)),
                      child: LayoutBuilder(
                        builder: (a1, c1) {
                          return Padding(
                            padding: EdgeInsets.all(
                                max(c1.maxHeight, c1.maxWidth) * 0.05),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.baseBorderRadius -
                                          (max(c1.maxHeight, c1.maxWidth) *
                                                  0.05) /
                                              2),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CachedNetworkImage(
                                        imageUrl: subCategory.image),
                                  ),
                                ),
                                Expanded(
                                    child: SizedBox.expand(
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: FittedBox(
                                          child: Text(
                                        subCategory.name,
                                        style: const TextStyle(
                                            color: AppTheme.white,
                                            fontWeight: FontWeight.bold),
                                      ))),
                                ))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
