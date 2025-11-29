import 'package:authentication/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Utilities/utilities_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class DCNCalculatorView extends StatefulWidget {
  const DCNCalculatorView({required Key key}) : super(key: key);

  @override
  State<DCNCalculatorView> createState() => DCNCalculatorViewState();
}

class DCNCalculatorViewState extends State<DCNCalculatorView> {
  late final GlobalKey<FormState> _formKey;

  late final TextEditingController _ageTextController;
  late final TextEditingController _heightTextController;
  late final TextEditingController _weightTextController;

  late final CaloriesCalculator? _calController;
  late List<String> _activityLevels;
  late Map<ActiveLevel, String> _mappedActivityLevels;

  ActiveLevel _selectedLevel = ActiveLevel.none;
  Gender _gender = Gender.male;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();

    _ageTextController = TextEditingController();
    _weightTextController = TextEditingController();
    _heightTextController = TextEditingController();
    _calController = CaloriesCalculator();

    if (kDebugMode) {
      _weightTextController.text = '180';
      _heightTextController.text = '173';
      _ageTextController.text = '21';
      _selectedLevel = ActiveLevel.BASIC;
      _gender = Gender.male;
    }

    _initActivityLevelSelector();
    super.initState();
  }

  void _initActivityLevelSelector() {
    _activityLevels = <String>[
      LocaleKeys
          .screens_utilities_calculators_calories_calc_activity_basic_metabolism
          .tr(),
      LocaleKeys.screens_utilities_calculators_calories_calc_activity_sendentary
          .tr(),
      LocaleKeys.screens_utilities_calculators_calories_calc_activity_light
          .tr(),
      LocaleKeys.screens_utilities_calculators_calories_calc_activity_modrate
          .tr(),
      LocaleKeys
          .screens_utilities_calculators_calories_calc_activity_very_active
          .tr(),
      LocaleKeys
          .screens_utilities_calculators_calories_calc_activity_extra_active
          .tr(),
    ];
    _mappedActivityLevels = _activityLevels.asMap().map((index, value) {
      return MapEntry(ActiveLevel.values[index], value);
    });
  }

  @override
  void dispose() {
    _weightTextController.dispose();
    _heightTextController.dispose();
    _ageTextController.dispose();
    super.dispose();
  }

  void reset() {
    _weightTextController.clear();
    _heightTextController.clear();
    _ageTextController.clear();
    _gender = Gender.male;
    _selectedLevel = ActiveLevel.none;
    if (mounted) setState(() {});
  }

  CaloriesResult? calculate() {
    if (!_formKey.currentState!.validate() ||
        _selectedLevel == ActiveLevel.none) return null;

    final age = int.parse(_ageTextController.text.trim());
    final weight = double.parse(_weightTextController.text.trim());
    final height = double.parse(_heightTextController.text.trim());

    final result = _calController!.calculate(
      dcnRequest: DCNRequest(
        age: age,
        height: height,
        weight: weight,
        gender: _gender,
        level: _selectedLevel,
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: KEdgeInsets.h20 +
            EdgeInsets.only(bottom: screenSize.height * 0.1, top: 10),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              GenderPicker(
                initialValue: _gender,
                onChanged: (gender) => setState(() => _gender = gender),
              ),
              const Space.v20(),
              _buildAgeField(),
              const Space.v20(),
              _buildWeightField(),
              const Space.v20(),
              _buildHeightField(),
              const Space.v20(),
              ListTile(
                onTap: () => _buildActivityLevelPicker(_mappedActivityLevels),
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  LocaleKeys
                      .screens_utilities_calculators_calories_calc_activity_title
                      .tr(),
                  style: theme(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 16),
                ),
                title: _selectedLevel != ActiveLevel.none
                    ? _activityText(_selectedLevel)
                    : Text(
                        LocaleKeys
                            .screens_utilities_calculators_calories_calc_activity_select
                            .tr(),
                        style: theme(context).textTheme.titleSmall,
                      ),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: CColors.nullableSwitchable(
                    context,
                    light: Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _buildActivityLevelPicker(Map<ActiveLevel, String> data) {
    final _selectedIndex =
        data.keys.toList().indexWhere((element) => element == _selectedLevel);
    WheelPicker(
      initialIndex: _selectedIndex == -1 ? 0 : _selectedIndex,
      onChanged: (index) {
        final level = data.keys.elementAt(index);
        setState(() => _selectedLevel = level);
      },
      delegate: ListDelegate(
        itemCount: data.length,
        builder: (context, index) {
          final title = data.values.elementAt(index);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: theme(context).textTheme.bodyLarge,
              ),
            ),
          );
        },
      ),
    ).show(context);
  }

  Text _activityText(ActiveLevel level) {
    return Text(
      _mappedActivityLevels[level] ?? "-",
      style: theme(context).textTheme.titleSmall,
    );
  }

  Widget _buildAgeField() {
    return CalculatorTextField(
      controller: _ageTextController,
      title: LocaleKeys.general_titles_age.tr(),
      maxLength: 3,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildWeightField() {
    return CalculatorTextField(
      controller: _weightTextController,
      title: LocaleKeys.screens_utilities_general_weight.tr(),
      hintText: LocaleKeys.screens_utilities_general_units_kg.tr(),
    );
  }

  Widget _buildHeightField() {
    return CalculatorTextField(
      controller: _heightTextController,
      title: LocaleKeys.screens_utilities_general_height.tr(),
      hintText: LocaleKeys.screens_utilities_general_units_cm.tr(),
    );
  }
}
