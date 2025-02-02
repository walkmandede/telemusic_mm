import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/models/artist_model.dart';
import 'package:telemusic_v2/src/models/category_model.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';

class DiscoverPageController extends GetxController {
  //baseVariables
  ValueNotifier<bool> xLoading = ValueNotifier(false);
  ApiRepo apiRepo = ApiRepo();

  //businessLogicVariables
  List<CategoryModel> allCategories = [];
  List<ArtistModel> allTop50Artists = [];

  @override
  void onInit() {
    initLoad();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  //functions
  Future<void> initLoad() async {
    xLoading.value = true;
    await fetchData();
    xLoading.value = false;
  }

  Future<void> fetchData() async {
    try {
      await Future.wait([_fetchAllCategories(), _fetchTop50Artists()]);
    } catch (e) {
      superPrint(e);
    }
  }

  Future<void> _fetchAllCategories() async {
    allCategories = await apiRepo.getAllCategories() ?? [];
  }

  Future<void> _fetchTop50Artists() async {
    allTop50Artists = await apiRepo.getTop50Artists() ?? [];
  }
}
