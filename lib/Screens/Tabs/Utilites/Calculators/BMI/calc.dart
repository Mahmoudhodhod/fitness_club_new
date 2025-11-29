import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Ads/ads_module.dart';
import 'package:the_coach/Modules/Utilities/utilities_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'result.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({Key? key}) : super(key: key);

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _heightTextController;
  late final TextEditingController _weightTextController;
  BMICalculator? _calcController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _heightTextController = TextEditingController();
    _weightTextController = TextEditingController();
    _calcController = BMICalculator();
    super.initState();
  }

  @override
  void dispose() {
    _heightTextController.dispose();
    _weightTextController.dispose();
    _calcController = null;
    super.dispose();
  }

  void _reset() {
    _heightTextController.clear();
    _weightTextController.clear();
  }

  void _performCalculations() {
    final height = double.parse(_heightTextController.text.trim());
    final weight = double.parse(_weightTextController.text.trim());
    _calcController!.calculate(height: height, weight: weight);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissed(
      child: Scaffold(
        appBar: CAppBar(
          header: "BMI",
          actions: [
            ResetTextButton(onPressed: _reset),
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
                      content: TextButton(
                        onPressed: () {
                          url_launcher.launchUrl(
                              Uri.parse("https://www.issaonline.com/bmi"));
                        },
                        child: Text("issaonline.com/bmi"),
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
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            _performCalculations();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BMIResultScreen(
                  result: BMIResultViewModel(
                    result: _calcController?.resultString,
                    value: _calcController?.result(),
                  ),
                ),
              ),
            );
          },
          child: Text(LocaleKeys.general_titles_calculate.tr()),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: KEdgeInsets.h20 +
                  EdgeInsets.only(bottom: screenSize.height * 0.1, top: 10),
              child: Column(
                children: [
                  _buildHeightField(),
                  Space.v20(),
                  _buildWeightField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightField() {
    return CalculatorTextField(
      controller: _weightTextController,
      title: LocaleKeys.screens_utilities_general_weight.tr(),
      hintText: LocaleKeys.screens_utilities_general_units_kg.tr(),
      maxLength: 3,
    );
  }

  Widget _buildHeightField() {
    return CalculatorTextField(
      controller: _heightTextController,
      title: LocaleKeys.screens_utilities_general_height.tr(),
      hintText: LocaleKeys.screens_utilities_general_units_cm.tr(),
      maxLength: 3,
    );
  }
}
