import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Utilities/utilities_module.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

//TODO: Swape (Category) with (Range)

///A very simple row wraper to register BMI values and thier ranges.
///
@immutable
class BMIRowData {
  ///The current user BMI value
  ///
  ///see also:
  ///* [BMIValue] enum
  final BMIValue value;

  ///The current row BMI range, (ex: `less than 16`).
  ///
  final String range;

  ///The current row BMI category, (ex: `normal`).
  ///
  final String category;
  BMIRowData({
    required this.value,
    required this.range,
    required this.category,
  });
}

///Preview the user resulted BMI value as a visial table with the available rangees
///and thier categories.
///
///(ex: range: `Less than 16` || category: `Severely Underweighted`).
///
class BMIResultTable extends StatelessWidget {
  ///The resulted user's BMI value.
  ///
  final BMIValue value;

  ///Constructs a BMI value previewer wich value.
  ///
  const BMIResultTable({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var copyWith = theme(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        );
    return Column(
      children: [
        InfoTable(
          flex: [1, 1],
          titleStyle: TextStyle(fontWeight: FontWeight.bold),
          detailsTextStyle: TextStyle(fontWeight: FontWeight.bold),
          rows: [
            InfoTableRow(
              title: LocaleKeys
                  .screens_utilities_calculators_BMI_calc_result_range
                  .tr(),
              detailsText: LocaleKeys
                  .screens_utilities_calculators_BMI_calc_result_category_title
                  .tr(),
              titleStyle: copyWith,
              detailsStyle: copyWith,
            ),
            ...List.generate(_list.length, (index) {
              final row = _list[index];
              final isSelected = row.value == value;
              return InfoTableRow(
                key: ValueKey(row.value),
                title: row.range,
                details: Center(child: Text(row.category)),
                bgColor: isSelected ? Colors.orange[800] : null,
                padding: const EdgeInsets.symmetric(vertical: 5.0),
              );
            }),
          ],
        ),
      ],
    );
  }

  static final _list = [
    BMIRowData(
      value: BMIValue.SEVERELY_UNDERWEIGHT,
      range: LocaleKeys.general_titles_ranges_less.tr(namedArgs: {"num": "16"}),
      category: LocaleKeys
          .screens_utilities_calculators_BMI_calc_result_category_sev_under
          .tr(),
    ),
    BMIRowData(
      value: BMIValue.UNDERWEIGHT,
      range: _fromToStrTr("16", "18.5"),
      category: LocaleKeys
          .screens_utilities_calculators_BMI_calc_result_category_under
          .tr(),
    ),
    BMIRowData(
      value: BMIValue.NORMAL,
      range: _fromToStrTr("18.5", "25"),
      category: LocaleKeys
          .screens_utilities_calculators_BMI_calc_result_category_normal
          .tr(),
    ),
    BMIRowData(
      value: BMIValue.OVERWEIGHT,
      range: _fromToStrTr("25", "30"),
      category: LocaleKeys
          .screens_utilities_calculators_BMI_calc_result_category_over
          .tr(),
    ),
    BMIRowData(
      value: BMIValue.OBESE_CLASS,
      range: LocaleKeys.general_titles_ranges_or_above
          .tr(namedArgs: {"num": "30"}),
      category: LocaleKeys
          .screens_utilities_calculators_BMI_calc_result_category_extreme
          .tr(),
    ),
  ];

  static String _fromToStrTr(String from, String to) {
    return LocaleKeys.general_titles_ranges_from_to
        .tr(namedArgs: {"from": from, "to": to});
  }
}
