import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Payment/payment.dart';

import '../ads_module.dart';

// const _kDisableAds = true;

class AdInterstitial {
  static final AdInterstitial _ad = AdInterstitial._internal();
  AdInterstitial._internal();

  factory AdInterstitial() {
    return _ad;
  }

  late Completer<InterstitialAd> _completer;

  Future<void> _createInterstitialAd() {
    _completer = Completer<InterstitialAd>();
    return InterstitialAd.load(
      adUnitId: AdsService.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          _completer.completeError(error);
        },
      ),
    );
  }

  Future<void> showDelayed([Duration d = const Duration(seconds: 1)]) {
    return Future.delayed(d).then((value) => show());
  }

  Future<void> show() async {
    // TODO: [VIP]
    return;

    final isVip = await isCurrentUserVIP(NavigationService.context!);
    if (isVip) return;
    _createInterstitialAd();
    try {
      final adf = await _completer.future;

      adf.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) async {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) async {
          ad.dispose();
          _createInterstitialAd();
        },
      );

      return adf.show();
    } catch (e) {
      debugPrint('[InterstitialAd] Error: $e');
    }
  }
}
