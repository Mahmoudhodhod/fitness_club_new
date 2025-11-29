import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Screens/Tabs/Utilites/Calculators/Carbs/calc.dart';

import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'Calculators/calculators.dart';

///document
@immutable
class CalculatorViewModel {
  final String title;
  final Widget? leading;
  final VoidCallback? onTap;
  const CalculatorViewModel({required this.title, this.leading, this.onTap});
}

class UtilitiesScreen extends StatefulWidget {
  const UtilitiesScreen({Key? key}) : super(key: key);

  @override
  _UtilitiesScreenState createState() => _UtilitiesScreenState();
}

class _UtilitiesScreenState extends State<UtilitiesScreen> {
  @override
  Widget build(BuildContext context) {
    final _calcs = [
      CalculatorViewModel(
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (_) => BMICalculatorScreen()));
        },
        leading: Icon(FontAwesomeIcons.clipboardList),
        title: LocaleKeys.screens_utilities_calculators_BMI_calc_title.tr(),
      ),
      CalculatorViewModel(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (_) => CaloriesCalculatorScreen()));
        },
        leading: Icon(FontAwesomeIcons.fireAlt),
        title:
            LocaleKeys.screens_utilities_calculators_calories_calc_title.tr(),
      ),
      CalculatorViewModel(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (_) => ProteinCalculatorScreen()));
        },
        leading: Icon(FontAwesomeIcons.drumstickBite),
        title: LocaleKeys.screens_utilities_calculators_protine_calc_title.tr(),
      ),
      CalculatorViewModel(
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (_) => CarbsCalculatorScreen()));
        },
        leading: Icon(FontAwesomeIcons.swimmer),
        title: LocaleKeys.screens_utilities_calculators_carbs_calc_title.tr(),
      ),
      CalculatorViewModel(
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (_) => FatCalculatorScreen()));
        },
        leading: Icon(FontAwesomeIcons.weight),
        title: LocaleKeys.screens_utilities_calculators_fat_calc_title.tr(),
      ),
    ];
    return Scaffold(
      drawer: const CDrawer(),
      appBar: CAppBar(header: LocaleKeys.general_titles_app_title.tr()),
      body: SafeArea(
        child: ListView.separated(
          itemCount: _calcs.length,
          separatorBuilder: (context, index) => Divider(
            indent: 20,
          ),
          itemBuilder: (context, index) {
            final calc = _calcs[index];
            return ListTile(
              onTap: calc.onTap,
              title: Text(
                calc.title,
                style: TextStyle(
                  color: CColors.nullableSwitchable(context,
                      light: CColors.darkerBlack, dark: Colors.grey.shade100),
                ),
              ),
              leading: calc.leading != null
                  ? IconTheme.merge(
                      data: IconThemeData(color: CColors.primary(context)),
                      child: calc.leading!,
                    )
                  : null,
              trailing: IconDirectional(
                Icons.chevron_left,
                color: CColors.nullableSwitchable(context,
                    light: CColors.darkerBlack, dark: Colors.grey.shade100),
              ),
            );
          },
        ),
      ),
    );
  }
}
