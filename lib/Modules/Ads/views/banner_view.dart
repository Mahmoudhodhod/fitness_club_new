import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:the_coach/Modules/Payment/payment.dart';

import '../widgets/widgets.dart';

class BannerView extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final AdSize size;
  const BannerView({
    Key? key,
    required this.child,
    this.margin,
    this.size = AdSize.fullBanner,
  }) : super(key: key);

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  @override
  Widget build(BuildContext context) {
    // TODO: [VIP]
    return widget.child;

    final p = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = p > 1;
    return VIPBuilder(
      builder: (context, isVip) {
        if (isVip) {
          return widget.child;
        }
        final padding = MediaQuery.of(context).padding;
        return Column(
          children: [
            Expanded(child: widget.child),
            SizedBox(
              height: isKeyboardOpen ? 0 : null,
              child: Material(
                type: MaterialType.transparency,
                child: AdBanner(
                  size: widget.size,
                  padding: EdgeInsets.only(bottom: 15) +
                      EdgeInsets.only(bottom: padding.bottom),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
