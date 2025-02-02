import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/network/api_end_points.dart';
import 'package:telemusic_v2/utils/services/network/api_request_model.dart';
import 'package:telemusic_v2/utils/services/network/api_service.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

class ForgetPasswordPageController extends GetxController {
  TextEditingController txtEmail = TextEditingController(text: "");
  TextEditingController txtOtp = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");
  TextEditingController txtConfirmPassword = TextEditingController(text: "");
  PageController pageController = PageController();

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

  Future<void> proceedRequestOtp() async {
    if (txtEmail.text.isEmpty) {
      DialogService().showConfirmDialog(
          context: Get.context!, label: "Email should not be empty!");
    } else {
      DialogService().showLoadingDialog(context: Get.context!);
      final response = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
        enumApiRequestMethods: EnumApiRequestMethods.post,
        url: ApiEndPoints.requestOtpForForgetPassword,
        data: {"email": txtEmail.text},
      ));
      DialogService().dismissDialog(context: Get.context!);
      superPrint(response.bodyData);
      // pageController.nextPage(
      //     duration: const Duration(milliseconds: 200), curve: Curves.linear);
    }
  }

  Future<void> proceedChangePassword() async {}
}
