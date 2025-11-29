import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'result.dart';

class CaloriesCalculatorScreen extends StatefulWidget {
  const CaloriesCalculatorScreen({Key? key}) : super(key: key);

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<CaloriesCalculatorScreen> {
  late final GlobalKey<DCNCalculatorViewState> _dcnCalculatorViewKey;

  @override
  void initState() {
    _dcnCalculatorViewKey = GlobalKey();
    super.initState();
  }

  void _performCalculations() {
    final result = _dcnCalculatorViewKey.currentState!.calculate();
    if (result == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CaloriesResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissed(
      child: Scaffold(
        appBar: CAppBar(
          header:
              LocaleKeys.screens_utilities_calculators_calories_calc_title.tr(),
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
                            """
Calculate men’s calorie needs is = 66.5 + 13.8 x (body weight in kilograms) + 5 x (body height in cm) divided by 6.8 x age. Meanwhile for women= 655.1 + 9.6 x (body weight in kilograms) + 1.9 x (body height in cm) divided by 4.7 x age.
""",
                            textDirection: ui.TextDirection.ltr,
                          ),
                          TextButton(
                            onPressed: () {
                              url_launcher.launchUrl(Uri.parse(
                                  "https://www.issaonline.com/blog/post/how-to-calculate-calories-for-greater-weight-loss-success"));
                            },
                            child: Text("issaonline.com/calories"),
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
          child: DCNCalculatorView(key: _dcnCalculatorViewKey),
        ),
      ),
    );
  }
}
