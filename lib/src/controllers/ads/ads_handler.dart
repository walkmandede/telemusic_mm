import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:telemusic_v2/src/controllers/ads/ads_helper.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';

class AdsHandler extends GetxController {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool isBannerAdLoaded = false;
  bool isInterstitialAdLoaded = false;
  bool isRewardedAdLoaded = false;
  DataController dataController = Get.find();

  int clickCount = 0;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  @override
  void dispose() {
    if (_bannerAd != null) {
      _bannerAd!.dispose();
    }
    super.dispose();
  }

  /// Initialize Google Mobile Ads SDK
  Future<void> initialize() async {
    await MobileAds.instance.initialize();

    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ["TEST_EMULATOR"]),
    );
  }

  void addClickCount() {
    clickCount = clickCount + 1;
    superPrint(clickCount, title: "Click Count");
    if (clickCount == 12) {
      clickCount = 0;
      loadInterstitialAd(onAdLoaded: () {
        showInterstitialAd();
      });
    }
  }

  /// Load Banner Ad
  void loadBannerAd({
    Function? onAdLoaded,
    Function? onAdFailedToLoad,
  }) {
    if (dataController.currentUser.value!.xPremium()) {
      return;
    }
    _bannerAd = BannerAd(
      adUnitId: AdsHelper.bottomBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerAdLoaded = true;
          if (onAdLoaded != null) onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          superPrint("${ad.responseInfo}-- \n--$error", title: "Ads");
          ad.dispose();
          isBannerAdLoaded = false;
          if (onAdFailedToLoad != null) onAdFailedToLoad(error);
        },
      ),
    );
    _bannerAd!.load();
  }

  /// Get Banner Ad Widget
  Widget getBannerAdWidget() {
    if (dataController.currentUser.value!.xPremium()) {
      return const SizedBox.shrink();
    }
    if (isBannerAdLoaded && _bannerAd != null) {
      return Center(
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Load Interstitial Ad
  void loadInterstitialAd({
    Function? onAdLoaded,
    Function? onAdFailedToLoad,
  }) {
    if (dataController.currentUser.value!.xPremium()) {}
    InterstitialAd.load(
      adUnitId: AdsHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isInterstitialAdLoaded = true;
          if (onAdLoaded != null) onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          print("Interstitial Ad failed to load: ${error.message}");
          isInterstitialAdLoaded = false;
          if (onAdFailedToLoad != null) onAdFailedToLoad(error);
        },
      ),
    );
  }

  /// Show Interstitial Ad
  void showInterstitialAd({
    Function? onAdClosed,
    Function? onAdFailedToShow,
  }) {
    if (dataController.currentUser.value!.xPremium()) {
      return;
    }
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          isInterstitialAdLoaded = false;
          if (onAdClosed != null) onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("Interstitial Ad failed to show: ${error.message}");
          ad.dispose();
          _interstitialAd = null;
          isInterstitialAdLoaded = false;
          if (onAdFailedToShow != null) onAdFailedToShow(error);
        },
      );
      _interstitialAd!.show();
    } else {
      print("Interstitial Ad not loaded yet!");
    }
  }

  /// Load Rewarded Ad
  void loadRewardedAd({
    required String adUnitId,
    Function? onAdLoaded,
    Function? onAdFailedToLoad,
  }) {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          isRewardedAdLoaded = true;
          if (onAdLoaded != null) onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          print("Rewarded Ad failed to load: ${error.message}");
          isRewardedAdLoaded = false;
          if (onAdFailedToLoad != null) onAdFailedToLoad(error);
        },
      ),
    );
  }

  /// Show Rewarded Ad
  void showRewardedAd({
    required Function(int rewardAmount) onRewardEarned,
    Function? onAdClosed,
    Function? onAdFailedToShow,
  }) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          isRewardedAdLoaded = false;
          if (onAdClosed != null) onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("Rewarded Ad failed to show: ${error.message}");
          ad.dispose();
          _rewardedAd = null;
          isRewardedAdLoaded = false;
          if (onAdFailedToShow != null) onAdFailedToShow(error);
        },
      );

      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          onRewardEarned(reward.amount.toInt());
        },
      );
    } else {
      print("Rewarded Ad not loaded yet!");
    }
  }
}
