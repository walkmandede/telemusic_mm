import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/views/auth/login/login_page.dart';
import 'package:telemusic_v2/src/views/auth/register/register_page.dart';
import 'package:telemusic_v2/utils/constants/app_assets.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';

class AuthHomePage extends StatefulWidget {
  const AuthHomePage({super.key});

  @override
  State<AuthHomePage> createState() => _AuthHomePageState();
}

class _AuthHomePageState extends State<AuthHomePage> {
  void _proceedLogin() async {
    Get.to(() => const LoginPage());
  }

  void _proceedRegister() async {
    Get.to(() => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: AppConstants.getBaseScaffoldPadding(),
          child: Stack(
            children: [
              SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: AppConstants.baseButtonHeight,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          vibrateNow();
                          _proceedRegister();
                        },
                        child: const Text(
                          "Sign up free",
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
                          _proceedLogin();
                        },
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100000))),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Get.width * 0.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10000000),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            AppAssets.appLogo,
                            errorBuilder: (context, error, stackTrace) {
                              superPrint(error);
                              return Text("Error in image");
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppConstants.basePadding,
                    ),
                    const Text(
                      "Millions of songs\nFree on Telemusic",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
