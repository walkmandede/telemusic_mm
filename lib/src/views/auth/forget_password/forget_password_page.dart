import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:telemusic_v2/src/views/auth/forget_password/c_forget_password_page_controller.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late ForgetPasswordPageController forgetPasswordPageController;

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
    forgetPasswordPageController = Get.put(ForgetPasswordPageController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: forgetPasswordPageController.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [_requestOtpSection(), _changeNewPasswordSection()],
        ),
      ),
    );
  }

  Widget _requestOtpSection() {
    return Padding(
      padding: AppConstants.getBaseScaffoldPadding(top: false),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  controller: forgetPasswordPageController.txtEmail,
                  onTapOutside: (event) => dismissKeyboard(),
                  style: AppTheme.appTextStyle1.copyWith(color: AppTheme.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: AppConstants.basePadding,
              ),
              SizedBox(
                width: double.infinity,
                height: AppConstants.baseButtonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    vibrateNow();
                    forgetPasswordPageController.proceedRequestOtp();
                  },
                  child: const Text("Continue"),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _changeNewPasswordSection() {
    return const Placeholder();
  }
}
