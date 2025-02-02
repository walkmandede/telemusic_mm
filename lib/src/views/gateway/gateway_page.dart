import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemusic_v2/injector.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/models/user_model.dart';
import 'package:telemusic_v2/src/views/auth/auth_home_page.dart';
import 'package:telemusic_v2/src/views/home/home_page.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/local_stroage/sp_keys.dart';
import 'package:telemusic_v2/utils/services/network/api_service.dart';

import '../../../utils/services/network/api_end_points.dart';
import '../../../utils/services/network/api_request_model.dart';

class GatewayPage extends StatefulWidget {
  const GatewayPage({super.key});

  @override
  State<GatewayPage> createState() => _GatewayPageState();
}

class _GatewayPageState extends State<GatewayPage> {
  late DataController dataController;

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _initLoad() async {
    await _injectDependencies();
    await _getAppRelatedData();
    await _localizeData();
  }

  _injectDependencies() async {
    await MyDependenciesInjector().injectDependencies();
    dataController = Get.find();
  }

  _getAppRelatedData() async {
    try {
      final response = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
        enumApiRequestMethods: EnumApiRequestMethods.get,
        url: ApiEndPoints.appInfo,
      ));
      if (response.xSuccess) {
        Iterable iterable = response.bodyData["data"] ?? [];
        for (final each in iterable) {
          String slug = each["slug"] ?? "";
          String detail = each["detail"] ?? "";
          if (slug == "about") {
            dataController.aboutAppDetail = detail;
          } else if (slug == "terms-of-use") {
            dataController.tncDetail = detail;
          } else if (slug == "privacy-policy") {
            dataController.privacyPolicyDetail = detail;
          }
        }
      }
      await Future.delayed(const Duration(seconds: 3));
    } catch (_) {}
  }

  _localizeData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final email = sharedPreferences.getString(SpKeys.email);
    final password = sharedPreferences.getString(SpKeys.password);

    if (email == null || password == null) {
      //go to auth Home Page
      Get.offAll(() => const AuthHomePage());
    } else {
      //do loging process
      try {
        await _proceedLoginProcess(email: email, password: password);
      } catch (_) {
        Get.offAll(() => const AuthHomePage());
      }
      Get.offAll(() => const HomePage());
    }
  }

  Future<void> _proceedLoginProcess(
      {required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
    } else {
      ApiRequestModel apiRequestData = ApiRequestModel(
          enumApiRequestMethods: EnumApiRequestMethods.post,
          url: ApiEndPoints.login,
          data: {"email": email, "password": password},
          headers: const {});
      ApiService apiService = ApiService();
      final response =
          await apiService.makeARequest(apiRequestData: apiRequestData);
      if (response.xSuccess) {
        try {
          DataController dataController = Get.find();
          dataController.apiToken = response.bodyData["login_token"] ?? "";
          dataController.currentUser.value =
              UserModel.fromJson(response.bodyData["data"] ?? {});

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.setString(SpKeys.email, email);
          await sharedPreferences.setString(SpKeys.password, password);
          Get.offAll(() => const HomePage());
        } catch (_) {
          throw Exception("");
        }
      } else {
        throw Exception("");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //this can be treaed as a splash loading screen (intro)
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
