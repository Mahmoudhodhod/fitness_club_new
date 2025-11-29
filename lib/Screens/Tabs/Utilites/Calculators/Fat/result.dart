import 'package:flutter/material.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';
import 'package:the_coach/Modules/Utilities/new_fat_controller.dart';

import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class FatResultScreen extends StatefulWidget {
  final FatResult result;
  const FatResultScreen({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  State<FatResultScreen> createState() => _FatResultScreenState();
}

class _FatResultScreenState extends State<FatResultScreen> {
  @override
  void initState() {
    AdInterstitial().show();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BannerView(
      child: BannerView(
        child: Scaffold(
          appBar: CAppBar(
            header: LocaleKeys.screens_utilities_calculators_calories_calc_result_title.tr(),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0) + const EdgeInsets.only(bottom: 30),
              child: FatsResultTable(result: widget.result),
            ),
          ),
        ),
      ),
    );
  }
}
