import 'dart:ui' as ui;

import 'package:authentication/authentication.dart';
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

@immutable
class ActiveLevelViewModel {
  final String title;
  final String? subTitle;
  final FitnessLevel level;
  const ActiveLevelViewModel({
    required this.title,
    this.subTitle,
    required this.level,
  });
}

class ProteinCalculatorScreen extends StatefulWidget {
  const ProteinCalculatorScreen({Key? key}) : super(key: key);

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<ProteinCalculatorScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _weightTextController;
  ProteinCalculator? _calController;
  FitnessLevel _fitnessLevel = FitnessLevel.NO_EXERCISE;
  Gender _gender = Gender.male;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _weightTextController = TextEditingController();
    _calController = ProteinCalculator();
    super.initState();
  }

  @override
  void dispose() {
    _weightTextController.dispose();
    _calController = null;
    super.dispose();
  }

  void _reset() {
    _weightTextController.clear();
    _fitnessLevel = FitnessLevel.NO_EXERCISE;
    _gender = Gender.male;
    setState(() {});
  }

  void _performCalculations() {
    final weight = double.parse(_weightTextController.text.trim());
    _calController!
        .calculate(weight: weight, gender: _gender, level: _fitnessLevel);
  }

  final _levels = [
    ActiveLevelViewModel(
      level: FitnessLevel.NO_EXERCISE,
      title: LocaleKeys
          .screens_utilities_calculators_protine_calc_fitness_level_no_exercise
          .tr(),
    ),
    ActiveLevelViewModel(
      level: FitnessLevel.LOW_LEVEL_TRAINING,
      title: LocaleKeys
          .screens_utilities_calculators_protine_calc_fitness_level_low_level_title
          .tr(),
      subTitle: LocaleKeys
          .screens_utilities_calculators_protine_calc_fitness_level_low_level_sub_title
          .tr(),
    ),
    ActiveLevelViewModel(
      level: FitnessLevel.ACTIVE_LEVEL_TRAINING,
      title: LocaleKeys
          .screens_utilities_calculators_protine_calc_fitness_level_active_level_title
          .tr(),
      subTitle: LocaleKeys
          .screens_utilities_calculators_protine_calc_fitness_level_active_level_sub_title
          .tr(),
    ),
    ActiveLevelViewModel(
      level: FitnessLevel.SPORTS,
      title: LocaleKeys
          .screens_utilities_calculators_protine_calc_fitness_level_sports_title
          .tr(),
      subTitle: LocaleKeys
          .screens_utilities_calculators_protine_calc_fitness_level_sports_sub_title
          .tr(),
    ),
    ActiveLevelViewModel(
      level: FitnessLevel.WEIGHT_TRAINING,
      title: LocaleKeys
          .screens_utilities_calculators_protine_calc_fitness_level_weight_training_title
          .tr(),
      subTitle: LocaleKeys
          .screens_utilities_calculators_protine_calc_fitness_level_weight_training_sub_title
          .tr(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissed(
      child: Scaffold(
        appBar: CAppBar(
          header:
              LocaleKeys.screens_utilities_calculators_protine_calc_title.tr(),
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
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            """
Weight x A.L = result
A.L depends on each sport
""",
                            textDirection: ui.TextDirection.ltr,
                          ),
                          TextButton(
                            onPressed: () {
                              url_launcher.launchUrl(
                                Uri.parse(
                                  "https://www.issaonline.com/blog/post/but-how-much-protein-do-i-really-need",
                                ),
                              );
                            },
                            child: Text("issaonline.com/protein"),
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
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            _performCalculations();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProteinResultScreen(
                  result: ProteinResultViewModel(
                      result: _calController?.resultString),
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
                  EdgeInsets.only(bottom: screenSize.height * 0.15, top: 10),
              child: Column(
                children: [
                  GenderPicker(
                    initialValue: _gender,
                    onChanged: (gender) {
                      setState(() {
                        _gender = gender;
                      });
                    },
                  ),
                  Space.v30(),
                  _buildWeightField(),
                  Space.v30(),
                  _buildFitnessLevelPicker(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFitnessLevelPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys
              .screens_utilities_calculators_protine_calc_fitness_level_title
              .tr(),
          style: theme(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _levels.length,
          itemBuilder: (context, index) {
            final level = _levels[index];
            return RadioListTile(
              title: Text(
                level.title,
                style: theme(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                level.subTitle ?? "-",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              contentPadding: EdgeInsets.zero,
              value: level.level,
              groupValue: _fitnessLevel,
              onChanged: (FitnessLevel? value) {
                setState(() => _fitnessLevel = value!);
              },
            );
          },
        )
      ],
    );
  }

  Widget _buildWeightField() {
    return CalculatorTextField(
      controller: _weightTextController,
      title: LocaleKeys.screens_utilities_general_weight.tr(),
      hintText: LocaleKeys.screens_utilities_general_units_kg.tr(),
    );
  }
}
