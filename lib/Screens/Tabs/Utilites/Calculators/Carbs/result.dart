import 'package:flutter/material.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';

import 'package:the_coach/Modules/Utilities/carbs_caluclator.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class CarbsResultScreen extends StatefulWidget {
  final CarbResult result;

  const CarbsResultScreen({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  State<CarbsResultScreen> createState() => _CarbsResultScreenState();
}

class _CarbsResultScreenState extends State<CarbsResultScreen> {
  @override
  void initState() {
    AdInterstitial().show();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BannerView(
      child: Scaffold(
        appBar: CAppBar(
          header: LocaleKeys.screens_utilities_calculators_calories_calc_result_title.tr(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0) + const EdgeInsets.only(bottom: 30),
            child: CabsResultTable(result: widget.result),
          ),
        ),
      ),
    );
  }
}
