import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/src/models/user_model.dart';
import 'package:telemusic_v2/src/views/home/home_page.dart';
import 'package:telemusic_v2/src/views/others/privacy_policy_page.dart';
import 'package:telemusic_v2/src/views/others/tnc_page.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/local_stroage/sp_keys.dart';
import 'package:telemusic_v2/utils/services/network/api_end_points.dart';
import 'package:telemusic_v2/utils/services/network/api_request_model.dart';
import 'package:telemusic_v2/utils/services/network/api_service.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController txtEmail = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");
  TextEditingController txtPasswordConfirm = TextEditingController(text: "");
  TextEditingController txtName = TextEditingController(text: "");
  TextEditingController txtPhone = TextEditingController(text: "");

  ValueNotifier<bool> xObsecuredPasswrord = ValueNotifier(true);
  ValueNotifier<bool> xObsecuredPasswrordConfirm = ValueNotifier(true);

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

  _initLoad() async {}

  Future<void> proceedRegister() async {
    if (txtEmail.text.isEmpty ||
        txtPassword.text.isEmpty ||
        txtName.text.isEmpty) {
      DialogService().showConfirmDialog(
          context: context,
          label: "Email, name or password field should not be empty");
    } else if (txtPassword.text != txtPasswordConfirm.text) {
      DialogService().showConfirmDialog(
          context: context, label: "Passwords do not match!");
    } else {
      ApiRequestModel apiRequestData = ApiRequestModel(
          enumApiRequestMethods: EnumApiRequestMethods.post,
          url: ApiEndPoints.register,
          data: {
            "email": txtEmail.text,
            "name": txtName.text,
            "mobile": txtPhone.text,
            "password": txtPassword.text,
            "password_confirmation": txtPasswordConfirm.text,
            "accept_term_and_policy": "1"
          },
          headers: const {});
      ApiService apiService = ApiService();
      DialogService().showLoadingDialog(context: Get.context!);
      final response =
          await apiService.makeARequest(apiRequestData: apiRequestData);
      DialogService().dismissDialog(context: Get.context!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up for free"),
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
                ...[
                  const Text(
                    "What's your name?",
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
                      controller: txtName,
                      onTapOutside: (event) => dismissKeyboard(),
                      style: AppTheme.appTextStyle1
                          .copyWith(color: AppTheme.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none),
                    ),
                  ),
                ],
                const SizedBox(
                  height: AppConstants.basePadding,
                ),
                ...[
                  const Text(
                    "What's your email?",
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
                      style: AppTheme.appTextStyle1
                          .copyWith(color: AppTheme.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none),
                    ),
                  ),
                ],
                const SizedBox(
                  height: AppConstants.basePadding,
                ),
                ...[
                  const Text(
                    "What's your phone? (Optional)",
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
                      controller: txtPhone,
                      onTapOutside: (event) => dismissKeyboard(),
                      style: AppTheme.appTextStyle1
                          .copyWith(color: AppTheme.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none),
                    ),
                  ),
                ],
                const SizedBox(
                  height: AppConstants.basePadding,
                ),
                ...[
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
                ],
                const SizedBox(
                  height: AppConstants.basePadding,
                ),
                ...[
                  const Text(
                    "Password Confirm",
                    style: TextStyle(
                        fontSize: AppConstants.baseFontSizeL,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white),
                  ),
                  const SizedBox(
                    height: AppConstants.basePadding / 2,
                  ),
                  ValueListenableBuilder(
                      valueListenable: xObsecuredPasswrordConfirm,
                      builder: (context, xopc, __) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(
                              AppConstants.baseBorderRadiusS),
                          child: TextField(
                            controller: txtPasswordConfirm,
                            obscureText: xopc,
                            onTapOutside: (event) => dismissKeyboard(),
                            style: AppTheme.appTextStyle1
                                .copyWith(color: AppTheme.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    vibrateNow();
                                    xObsecuredPasswrordConfirm.value =
                                        !xObsecuredPasswrordConfirm.value;
                                  },
                                  child: Icon(xopc
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                )),
                          ),
                        );
                      }),
                ],
                const SizedBox(
                  height: AppConstants.basePadding,
                ),
                const Divider(
                  color: AppTheme.lightGray,
                ),
                const SizedBox(
                  height: AppConstants.basePadding,
                ),
                ...[
                  const Text(
                      "By tapping 'Register', you agree to the Telemusic Terms"),
                  TextButton(
                      onPressed: () {
                        vibrateNow();
                        Get.to(() => const TncPage());
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Text("Terms and conditions")),
                  const Text(
                      "To learn more about how Telemusic collects, uses, shares and protects your personal data, please see the Spotify Privacy Policy."),
                  TextButton(
                      onPressed: () {
                        vibrateNow();
                        Get.to(() => const PrivacyPolicyPage());
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Text("Privacy policy")),
                ],
                const SizedBox(
                  height: AppConstants.basePadding,
                ),
                SizedBox(
                  height: AppConstants.baseButtonHeight,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      vibrateNow();
                      proceedRegister();
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppConstants.basePadding / 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
