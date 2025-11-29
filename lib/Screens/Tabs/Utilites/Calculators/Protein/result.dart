import 'package:flutter/material.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';

import 'package:utilities/utilities.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class ProteinResultViewModel {
  final String? result;
  ProteinResultViewModel({
    required this.result,
  });
}

class ProteinResultScreen extends StatefulWidget {
  final ProteinResultViewModel result;
  const ProteinResultScreen({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  State<ProteinResultScreen> createState() => _ProteinResultScreenState();
}

class _ProteinResultScreenState extends State<ProteinResultScreen> {
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys
                      .screens_utilities_calculators_protine_calc_result_required_protein
                      .tr(),
                  style: theme(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.result.result ?? "-",
                  style: theme(context).textTheme.displayLarge?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                ),
                Text(
                  LocaleKeys.screens_utilities_general_units_g.tr(),
                  style: theme(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
