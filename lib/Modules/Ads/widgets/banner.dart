import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:the_coach/Modules/Payment/payment.dart';

// import 'package:the_coach/Modules/ads/ads_service.dart';

class AdBanner extends StatefulWidget {
  final AdSize size;
  final EdgeInsetsGeometry? padding;
  const AdBanner({
    Key? key,
    this.size = AdSize.banner,
    this.padding,
  }) : super(key: key);

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  late AdSize _adSize;

  @override
  void initState() {
    _adSize = widget.size;
    Future.delayed(Duration(seconds: 1), _initBanners);
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AdBanner oldWidget) {
    if (oldWidget.size != widget.size) {
      _adSize = widget.size;
      _bannerAd?.dispose();
      _initBanners();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _initBanners() {
    // TODO: [VIP]
    return;

    // _bannerAd = BannerAd(
    //   size: _adSize,
    //   adUnitId: AdsService.bannerAdUnitId,
    //   listener: AdsService.defaultListener,
    //   request: AdRequest(),
    // )..load();
    // if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: [VIP]
    return const SizedBox.shrink();

    // return VIPBuilder(
    //   builder: (context, isVip) {
    //     if (isVip) {
    //       return const SizedBox.shrink();
    //     }

    //     Widget child = Material(
    //       type: MaterialType.transparency,
    //       child: SizedBox.square(
    //         dimension: 20,
    //         child: Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
    //       ),
    //     );

    //     if (_bannerAd != null) {
    //       child = AdWidget(ad: _bannerAd!);
    //     }
    //     return Padding(
    //       padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 10),
    //       child: SizedBox.fromSize(
    //         size: _adSize.size,
    //         child: child,
    //       ),
    //     );
    //   },
    // );
  }
}

extension on AdSize {
  Size get size {
    return Size(width.toDouble(), height.toDouble());
  }
}
