import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/views/music_player/each_music_display_widget.dart';
import 'package:telemusic_v2/src/views/search/c_search_page_controller.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchPageController searchPageController;

  @override
  void initState() {
    searchPageController = Get.put(SearchPageController());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.only(
            left: AppConstants.basePadding,
            right: AppConstants.basePadding,
            top: AppConstants.basePadding,
            bottom: AppConstants.basePadding),
        child: Column(
          children: [
            searchBar(),
            AppConstants.basePadding.heightBox(),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: searchPageController.xFetching,
                builder: (context, xFetching, child) {
                  if (xFetching) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else {
                    return musicDisplayWidget();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return SizedBox(
      height: AppConstants.baseButtonHeight,
      child: Center(
        child: TextField(
          controller: searchPageController.txtSearch,
          onTapOutside: (event) {
            vibrateNow();
            dismissKeyboard();
          },
          decoration: const InputDecoration(
              hintText: "Search by song name", isDense: true),
          onChanged: (value) {
            searchPageController.resetTimer();
          },
          onSubmitted: (value) {
            searchPageController.resetTimer();
          },
          onEditingComplete: () {
            searchPageController.resetTimer();
          },
        ),
      ),
    );
  }

  Widget musicDisplayWidget() {
    final shownData = searchPageController.shownData;
    if (shownData.isEmpty) {
      return const Center(
        child: Text("No music with such name!"),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.only(),
        itemCount: shownData.length,
        itemBuilder: (context, index) {
          final each = shownData[index];
          return EachMusicDisplayWidget(musicModel: each, serialNo: index + 1);
        },
      );
    }
  }
}
