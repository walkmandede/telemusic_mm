import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:telemusic_v2/src/models/music_model.dart';
import 'package:telemusic_v2/src/models/payment_method_model.dart';
import 'package:telemusic_v2/src/models/user_model.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';

class DataController extends GetxController {
  String apiToken = "";
  ValueNotifier<UserModel?> currentUser = ValueNotifier(null);
  ValueNotifier<PaymentMethodModel?> allPaymentMethodModel =
      ValueNotifier(null);
  String aboutAppDetail = "<h1>App Detail</h1>";
  String tncDetail = "<h1>T&C Detail</h1>";
  String privacyPolicyDetail = "<h1>Privacy Policy</h1>";

  String appVersion = "2.0.0";

  ValueNotifier<List<MusicModel>> favoriteList = ValueNotifier([]);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> updateFavoriteList() async {
    favoriteList.value = [];
    try {
      List<MusicModel> temp = await ApiRepo().getFavorites();
      favoriteList.value = [...temp];
    } catch (e) {
      superPrint(e);
    }
  }

  bool xIsFavorite({required String audioUrl}) {
    bool xHadData = false;
    try {
      for (final each in favoriteList.value) {
        if (each.audioUrl == audioUrl) {
          xHadData = true;
          break;
        }
      }
    } catch (_) {}
    return xHadData;
  }

  Future<void> updateUserInfo() async {
    final result = await ApiRepo().getUserSettingDetail();
    currentUser.value = UserModel.fromJson(result.bodyData["data"]);
    allPaymentMethodModel.value = PaymentMethodModel.fromMap(
        data: result.bodyData["payment_gateways"] ?? {});
  }
}
