import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  AdsService._();

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1346493329974070~4204964664";
    }
    return "ca-app-pub-1346493329974070~7945636414";
  }

  static String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716';
    }
    return _liveBannerAdId();
  }

  static String _liveBannerAdId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-1346493329974070/2244671455";
    }
    return "ca-app-pub-1346493329974070/8611773212";
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid ? 'ca-app-pub-3940256099942544/1033173712' : 'ca-app-pub-3940256099942544/4411468910';
    }
    return _liveInterstitialAdId();
  }

  static String _liveInterstitialAdId() {
    if (Platform.isAndroid) {
      return "ca-app-pub-1346493329974070/6846261448";
    }
    return "ca-app-pub-1346493329974070/8649880787";
  }

  static BannerAdListener get defaultListener {
    return BannerAdListener(
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
      },
    );
  }
}
