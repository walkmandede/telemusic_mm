import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/models/album_model.dart';
import 'package:telemusic_v2/src/models/artist_model.dart';
import 'package:telemusic_v2/src/models/category_model.dart';
import 'package:telemusic_v2/src/models/sub_category_model.dart';
import 'package:telemusic_v2/src/views/album/album_detail_page.dart';
import 'package:telemusic_v2/src/views/artist/detail/artist_detail_page.dart';
import 'package:telemusic_v2/src/views/discover/c_discover_page_controller.dart';
import 'package:telemusic_v2/src/views/discover/widgets/w_discover_loading_widget.dart';
import 'package:telemusic_v2/src/views/discover/widgets/w_each_category_widget.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late DiscoverPageController discoverPageController;

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  @override
  void dispose() {
    //
    super.dispose();
  }

  _initLoad() async {
    discoverPageController = Get.put(DiscoverPageController());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: LayoutBuilder(builder: (a1, c1) {
        return Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: ValueListenableBuilder(
              valueListenable: discoverPageController.xLoading,
              builder: (context, xLoading, child) {
                if (xLoading) {
                  return const DiscoverLoadingWidget();
                } else {
                  final shownData = [
                    ...discoverPageController.allCategories.reversed
                  ];
                  return RefreshIndicator.adaptive(
                    onRefresh: () async {
                      await discoverPageController.fetchData();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          right: 0, left: 0, bottom: 0, top: 0),
                      itemCount: shownData.length + 1,
                      itemBuilder: (context, sdi) {
                        //top 50
                        if (sdi == 0) {
                          final top50Artists =
                              discoverPageController.allTop50Artists;
                          if (top50Artists.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return EachCategoryWidget(
                            onClickEach: (subCategory, category) {
                              final artist = subCategory.data as ArtistModel;
                              Get.to(
                                  () => ArtistDetailPage(artistModel: artist));
                            },
                            eachCategory: CategoryModel(
                                categoryName: "Top 50 Artists",
                                imagePath: "",
                                subCategories: top50Artists.map((each) {
                                  return SubCategoryModel(
                                      id: each.id,
                                      image: each.image,
                                      isFeatured: each.isFeatured,
                                      isRecommended: each.isRecommended,
                                      isTrending: each.isTrending,
                                      name: each.artistName,
                                      slug: each.artistSlug,
                                      data: each,
                                      streamCounts:
                                          each.enumStreamChannelCountMap);
                                }).toList()),
                          );
                        }

                        //others
                        final eachCategory = shownData[sdi - 1];
                        if (eachCategory.subCategories.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return EachCategoryWidget(
                          eachCategory: eachCategory,
                          onClickEach: (subCategory, category) {
                            final trimmed = category.categoryName
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
                                        isRecommended:
                                            subCategory.isRecommended,
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
                                        isRecommended:
                                            subCategory.isRecommended,
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
                                      enumStreamChannelCountMap: const {},
                                      dob: "")));
                            } else if (trimmed.contains("genre")) {
                              superPrint("Genre");
                            }
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ));
      }),
    );
  }
}
