import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/my_audio_handler.dart';
import 'package:telemusic_v2/src/models/album_model.dart';
import 'package:telemusic_v2/src/models/artist_model.dart';
import 'package:telemusic_v2/src/models/music_model.dart';
import 'package:telemusic_v2/src/views/artist/detail/widgets/w_album_section.dart';
import 'package:telemusic_v2/src/views/artist/detail/widgets/w_music_section.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';
import '../../../../utils/constants/app_functions.dart';

enum EnumArtistDetailPageTab {
  music(label: "Music", shownWidget: ArtistDetailMusicSection()),
  album(label: "Album", shownWidget: ArtistDetailAlbumSection());

  final String label;
  final Widget shownWidget;
  const EnumArtistDetailPageTab(
      {required this.label, required this.shownWidget});
}

class ArtistDetailPageController extends GetxController {
  ValueNotifier<bool> xLoading = ValueNotifier(false);
  ScrollController pageScrollController = ScrollController();
  ValueNotifier<double> pageScrolledValue = ValueNotifier(0); // 0 - 1
  ApiRepo apiRepo = ApiRepo();

  List<MusicModel> allMusics = [];
  List<AlbumModel> allAlbums = [];
  late ArtistModel artist;

  ValueNotifier<EnumArtistDetailPageTab> selectedTab =
      ValueNotifier(EnumArtistDetailPageTab.music);

  @override
  void onInit() {
    // _initLoad();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  initLoad({required ArtistModel artistModel}) async {
    artist = artistModel;
    pageScrollController.addListener(
      () {
        final scrolledAmount = pageScrollController.position.pixels;
        if (scrolledAmount <= 0) {
          pageScrolledValue.value = 0;
        } else if (scrolledAmount >= Get.width) {
          pageScrolledValue.value = 1;
        } else {
          pageScrolledValue.value = scrolledAmount / Get.width;
        }
      },
    );
    await fetchData();
  }

  Future<void> fetchData() async {
    xLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      await Future.wait([_fetchAllMusics(), _fetchAllAlbums()]);
    } catch (e) {
      superPrint(e);
    }
    xLoading.value = false;
  }

  Future<void> _fetchAllMusics() async {
    allMusics = await apiRepo.getMusicByCategory(
            id: artist.id.toString(), type: "Artists") ??
        [];
  }

  Future<void> _fetchAllAlbums() async {
    allAlbums = (await apiRepo.getAllAlbumsByCategory() ?? []).where((each) {
      if (each.artistIds.contains(artist.id.toString())) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  void changeTab({required EnumArtistDetailPageTab tab}) {
    selectedTab.value = tab;
  }

  Future<void> proceedOnClickPlayButton(
      {required MusicModel musicModel}) async {
    await audioHandler.playAllSongs(
        songs: [...allMusics.map((e) => e.convertToMediaItem())],
        index: allMusics.indexOf(musicModel),
        xNetworkSong: true);
  }
}
