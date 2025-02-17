import 'dart:io';

// Android
// APP ID - ca-app-pub-7067648408847002~8209941123
// Banner - /22920965380/23423432342
// Android Banner New Tag - /22920965380/9974390
// Interstitial - /22920965380/234234243

// iOS
// APP ID - ca-app-pub-7067648408847002~1230904773
// Banner - /22920965380/202400
// iOS Banner New Tag - /22920965380/4747748
// Interstitial - /22920965380/202411

// - /22920965380/84748484
class AdsHelper {
  static const xTestMode = false;
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return xTestMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : '/22920965380/84748484';
      // : '/22920965380/23423432342'; // Google Admob Test ID
    } else if (Platform.isIOS) {
      return xTestMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : '/22920965380/84748484';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bottomBannerAdUnitId {
    if (Platform.isAndroid) {
      return xTestMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : '/22920965380/84748484';
      // : '/22920965380/9974390';
    } else if (Platform.isIOS) {
      return xTestMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : '/22920965380/84748484';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return xTestMode
          ? 'ca-app-pub-3940256099942544/1033173712'
          : '/22920965380/234234243';
    } else if (Platform.isIOS) {
      return xTestMode
          ? 'ca-app-pub-3940256099942544/1033173712'
          : '/22920965380/202411';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
