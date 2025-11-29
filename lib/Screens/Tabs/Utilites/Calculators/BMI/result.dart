import 'package:flutter/material.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Utilities/utilities_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class BMIResultViewModel {
  final String? result;
  final BMIValue? value;
  BMIResultViewModel({
    required this.result,
    required this.value,
  });
}

class BMIResultScreen extends StatefulWidget {
  final BMIResultViewModel result;
  const BMIResultScreen({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  State<BMIResultScreen> createState() => _BMIResultScreenState();
}

class _BMIResultScreenState extends State<BMIResultScreen> {
  @override
  void initState() {
    AdInterstitial().show();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BannerView(
      child: Scaffold(
        appBar: CAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(10.0) + const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Text(
                  LocaleKeys
                      .screens_utilities_calculators_BMI_calc_result_your_score
                      .tr(),
                  style: theme(context).textTheme.titleLarge,
                ),
                Text(
                  widget.result.result ?? "-",
                  style: theme(context).textTheme.displayLarge?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                ),
                Space.v20(),
                BMIResultTable(
                  value: widget.result.value ?? BMIValue.UNKNOWN,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
