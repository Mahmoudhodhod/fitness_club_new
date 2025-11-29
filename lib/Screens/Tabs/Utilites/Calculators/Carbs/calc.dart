import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';
import 'package:the_coach/Modules/Utilities/carbs_caluclator.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'result.dart';

class CarbsCalculatorScreen extends StatefulWidget {
  const CarbsCalculatorScreen({Key? key}) : super(key: key);

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<CarbsCalculatorScreen> {
  late final GlobalKey<DCNCalculatorViewState> _dcnCalculatorViewKey;
  late final CarbsCalculator _carbsCalculator;

  @override
  void initState() {
    _dcnCalculatorViewKey = GlobalKey();
    _carbsCalculator = CarbsCalculator();
    super.initState();
  }

  void _performCalculations() {
    final caloriesResult = _dcnCalculatorViewKey.currentState!.calculate();
    if (caloriesResult == null) return;

    final result = _carbsCalculator.calculateFromCaloriesResult(
        caloriesResult: caloriesResult);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CarbsResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissed(
      child: Scaffold(
        appBar: CAppBar(
          header:
              LocaleKeys.screens_utilities_calculators_carbs_calc_title.tr(),
          actions: [
            ResetTextButton(
              onPressed: () => _dcnCalculatorViewKey.currentState!.reset(),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      surfaceTintColor: Colors.transparent,
                      title:
                          Text(LocaleKeys.general_titles_how_we_calculate.tr()),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Calculating 40 to 60 percent of your total calorie intake, and dividing by 4.",
                            textDirection: ui.TextDirection.ltr,
                          ),
                          TextButton(
                            onPressed: () {
                              url_launcher.launchUrl(
                                Uri.parse(
                                    "https://www.issaonline.com/blog/post/help-clients-get-results-with-carb-cycling"),
                              );
                            },
                            child: Text("issaonline.com/carbs"),
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(LocaleKeys.general_titles_close.tr()),
                        ),
                      ],
                    );
                  },
                );
              },
              iconSize: 17,
              color: CColors.primary(context),
              icon: Icon(FontAwesomeIcons.exclamation),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CustomButton(
          visualDensity: VisualDensity.standard,
          onPressed: _performCalculations,
          child: Text(LocaleKeys.general_titles_calculate.tr()),
        ),
        body: SafeArea(
          child: DCNCalculatorView(
            key: _dcnCalculatorViewKey,
          ),
        ),
      ),
    );
  }
}
