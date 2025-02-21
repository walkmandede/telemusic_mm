import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telemusic_v2/injector.dart';
import '../../constants/app_constants.dart';

DialogRoute? dialogRoute;

class DialogService {
  void dismissDialog({required BuildContext context}) {
    try {
      if (dialogRoute != null) {
        Navigator.of(context).removeRoute(dialogRoute!);
        dialogRoute = null;
      }
    } catch (_) {}
  }

  Future<void> showConfirmDialog({
    required BuildContext context,
    String label = "Are you sure?",
    String? yesLabel,
    String? noLabel,
    Function()? onClickYes,
    Function()? onClickNo,
  }) async {
    if (dialogRoute != null) {
      dismissDialog(context: context);
    }

    dialogRoute = DialogRoute(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          // backgroundColor: AppColors.bg1,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.baseBorderRadius)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.basePaddingL,
                vertical: AppConstants.basePaddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: AppConstants.baseFontSizeL,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    // const Expanded(child: SizedBox.shrink()),
                    if (noLabel != null)
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: AppConstants.baseButtonHeightMS,
                          child: OutlinedButton(
                            onPressed: () {
                              if (onClickNo != null) onClickNo();
                              dismissDialog(context: context);
                            },
                            style: OutlinedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10000))),
                            child: Text(
                              noLabel,
                              style: const TextStyle(
                                fontSize: AppConstants.baseFontSizeM,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (noLabel != null)
                      const SizedBox(
                        width: 10,
                      ),
                    if (yesLabel != null)
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: AppConstants.baseButtonHeightMS,
                          child: ElevatedButton(
                            onPressed: () {
                              if (onClickYes != null) onClickYes();
                              dismissDialog(context: context);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                            ),
                            child: Text(
                              yesLabel,
                              style: const TextStyle(
                                fontSize: AppConstants.baseFontSizeM,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (yesLabel == null && noLabel == null)
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: AppConstants.baseButtonHeightMS,
                          child: ElevatedButton(
                            onPressed: () {
                              if (onClickYes != null) onClickYes();
                              dismissDialog(context: context);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                            ),
                            child: const Text(
                              "Close",
                              style: TextStyle(
                                fontSize: AppConstants.baseFontSizeM,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
    Navigator.of(context).push(dialogRoute!);
  }

  Future<void> showCustomDialog({
    required BuildContext context,
    required Widget widget,
  }) async {
    if (dialogRoute != null) {
      dismissDialog(context: context);
    }

    dialogRoute = DialogRoute(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          // backgroundColor: AppColors.bg1,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.baseBorderRadius)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.basePaddingL,
                vertical: AppConstants.basePaddingL),
            child: widget,
          ),
        );
      },
    );
    Navigator.of(context).push(dialogRoute!);
  }

  Future<void> showLoadingDialog({
    required BuildContext context,
  }) async {
    if (dialogRoute != null) {
      dismissDialog(context: context);
    }

    dialogRoute = DialogRoute(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.basePaddingL,
                vertical: AppConstants.basePaddingL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      shape: const CircleBorder(),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: CupertinoActivityIndicator(
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    Navigator.of(context).push(dialogRoute!);
  }
}
