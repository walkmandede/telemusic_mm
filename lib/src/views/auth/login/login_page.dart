import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/src/models/user_model.dart';
import 'package:telemusic_v2/src/views/auth/forget_password/forget_password_page.dart';
import 'package:telemusic_v2/src/views/home/home_page.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/local_stroage/sp_keys.dart';
import 'package:telemusic_v2/utils/services/network/api_end_points.dart';
import 'package:telemusic_v2/utils/services/network/api_request_model.dart';
import 'package:telemusic_v2/utils/services/network/api_service.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtEmail = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");
  ValueNotifier<bool> xObsecuredPasswrord = ValueNotifier(true);

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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    txtEmail.text = sharedPreferences.getString(SpKeys.email) ?? "";
  }

  Future<void> proceedLogin() async {
    if (txtEmail.text.isEmpty || txtPassword.text.isEmpty) {
      DialogService().showConfirmDialog(
          context: context,
          label: "Email or password field should not be empty");
    } else {
      ApiRequestModel apiRequestData = ApiRequestModel(
          enumApiRequestMethods: EnumApiRequestMethods.post,
          url: ApiEndPoints.login,
          data: {"email": txtEmail.text, "password": txtPassword.text},
          headers: const {});
      ApiService apiService = ApiService();
      DialogService().showLoadingDialog(context: Get.context!);
      final response =
          await apiService.makeARequest(apiRequestData: apiRequestData);
      DialogService().dismissDialog(context: Get.context!);
      superPrint(response.bodyData);
      if (response.xSuccess) {
        try {
          DataController dataController = Get.find();
          dataController.apiToken = response.bodyData["login_token"] ?? "";
          dataController.currentUser.value =
              UserModel.fromJson(response.bodyData["data"] ?? {});

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.setString(SpKeys.email, txtEmail.text);
          await sharedPreferences.setString(SpKeys.password, txtPassword.text);
          Get.offAll(() => const HomePage());
        } catch (_) {
          DialogService().showConfirmDialog(
              context: Get.context!, label: "Something went wrong!");
        }
      } else {
        DialogService()
            .showConfirmDialog(context: Get.context!, label: response.message);
      }
    }
  }

  Future<void> proceedForgotPassword() async {
    Get.to(() => const ForgetPasswordPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: AppConstants.getBaseScaffoldPadding(top: false),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: AppConstants.basePadding,
                ),
                const Text(
                  "Email",
                  style: TextStyle(
                      fontSize: AppConstants.baseFontSizeL,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white),
                ),
                const SizedBox(
                  height: AppConstants.basePadding / 2,
                ),
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppConstants.baseBorderRadiusS),
                  child: TextField(
                    controller: txtEmail,
                    onTapOutside: (event) => dismissKeyboard(),
                    style:
                        AppTheme.appTextStyle1.copyWith(color: AppTheme.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: AppConstants.basePadding,
                ),
                const Text(
                  "Password",
                  style: TextStyle(
                      fontSize: AppConstants.baseFontSizeL,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white),
                ),
                const SizedBox(
                  height: AppConstants.basePadding / 2,
                ),
                ValueListenableBuilder(
                    valueListenable: xObsecuredPasswrord,
                    builder: (context, xop, __) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(
                            AppConstants.baseBorderRadiusS),
                        child: TextField(
                          controller: txtPassword,
                          obscureText: xop,
                          onTapOutside: (event) => dismissKeyboard(),
                          style: AppTheme.appTextStyle1
                              .copyWith(color: AppTheme.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: () {
                                  vibrateNow();
                                  xObsecuredPasswrord.value =
                                      !xObsecuredPasswrord.value;
                                },
                                child: Icon(xop
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              )),
                        ),
                      );
                    }),
                const SizedBox(
                  height: AppConstants.basePadding,
                ),
                SizedBox(
                  height: AppConstants.baseButtonHeight,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      vibrateNow();
                      proceedLogin();
                    },
                    child: const Text(
                      "Log in now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppConstants.basePadding / 2,
                ),
                SizedBox(
                  height: AppConstants.baseButtonHeight,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      vibrateNow();
                      proceedForgotPassword();
                    },
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100000))),
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                          color: AppTheme.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
