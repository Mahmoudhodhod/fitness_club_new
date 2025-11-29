import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';
import 'package:the_coach/Modules/Utilities/utilities_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'result.dart';

class FatCalculatorScreen extends StatefulWidget {
  const FatCalculatorScreen({Key? key}) : super(key: key);

  @override
  _FatCalculatorScreenState createState() => _FatCalculatorScreenState();
}

class _FatCalculatorScreenState extends State<FatCalculatorScreen> {
  late final GlobalKey<DCNCalculatorViewState> _dcnCalculatorViewKey;
  late final NewFatController _fatsCalculator;

  @override
  void initState() {
    _dcnCalculatorViewKey = GlobalKey();
    _fatsCalculator = NewFatController();
    super.initState();
  }

  void _performCalculations() {
    final caloriesResult = _dcnCalculatorViewKey.currentState!.calculate();
    if (caloriesResult == null) return;

    final result = _fatsCalculator.calculateFromCaloriesResult(
        caloriesResult: caloriesResult);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FatResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissed(
      child: Scaffold(
        appBar: CAppBar(
          header: LocaleKeys.screens_utilities_calculators_fat_calc_title.tr(),
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
                            "Calculating 10 to 20 percent of your total calorie intake, and dividing by 9.",
                            textDirection: ui.TextDirection.ltr,
                          ),
                          TextButton(
                            onPressed: () {
                              url_launcher.launchUrl(
                                Uri.parse(
                                    "https://www.bodybuilding.com/fun/fats_calculator.htm"),
                              );
                            },
                            child: Text("bodybuilding.com/fats_calculator"),
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
