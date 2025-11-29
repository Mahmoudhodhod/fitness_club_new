import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:utilities/utilities.dart' show theme;

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Utilities/carbs_caluclator.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'calories_table.dart';
import 'flexable_data_table.dart';

@immutable
class CarbsResultRowViewModel {
  final String title;
  final CarbResultRow result;
  const CarbsResultRowViewModel({
    required this.title,
    required this.result,
  });
}

class CabsResultTable extends StatelessWidget {
  final CarbResult result;
  const CabsResultTable({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _data = [
      CarbsResultRowViewModel(
        title: LocaleKeys
            .screens_utilities_calculators_calories_calc_result_cal_to_mentain
            .tr(),
        result: result.toMaintainWeight,
      ),
      CarbsResultRowViewModel(
        title: CaloriesResultTable.calToLossPerWeek(.5),
        result: result.toLossHalfKGPerWeek,
      ),
      CarbsResultRowViewModel(
        title: CaloriesResultTable.calToLossPerWeek(1),
        result: result.toLossKGPerWeek,
      ),
      CarbsResultRowViewModel(
        title: CaloriesResultTable.calToGainPerWeek(.5),
        result: result.toGainHalfKGPerWeek,
      ),
      CarbsResultRowViewModel(
        title: CaloriesResultTable.calToGainPerWeek(1),
        result: result.toGainKGPerWeek,
      ),
    ];
    return FlexibleDataTable(
      flexes: [2, 1, 1, 1],
      columns: [
        DataColumn(label: Text(LocaleKeys.screens_utilities_general_goal.tr())),
        DataColumn(
            label: Text(LocaleKeys
                .screens_utilities_calculators_calories_calc_dcn
                .tr())),
        const DataColumn(label: Text("40%")),
        const DataColumn(label: Text("50%")),
      ],
      rows: List.generate(
        _data.length,
        (index) {
          final model = _data[index];
          final result = model.result;
          return DataRow(
            color: WidgetStateProperty.resolveWith<Color>((_) {
              return index.isOdd
                  ? CColors.switchable(
                      context,
                      dark: CColors.darkerBlack,
                      light: Colors.grey.shade200,
                    )
                  : Colors.transparent;
            }),
            cells: [
              DataCell(Text(
                model.title,
                textAlign: TextAlign.center,
              )),
              DataCell(CaloryCellDetails(
                  LocaleKeys.screens_utilities_general_units_calory_num.tr(
                namedArgs: {
                  'num': result.dcn.toStringResult(),
                },
              ))),
              DataCell(CaloryCellDetails(
                LocaleKeys.screens_utilities_general_units_g_num.tr(
                  namedArgs: {
                    'num': "${result.fortyPresentDCN.toStringResult()}",
                  },
                ),
              )),
              DataCell(CaloryCellDetails(
                LocaleKeys.screens_utilities_general_units_g_num.tr(
                  namedArgs: {
                    'num': "${result.fiftyPresentDCN.toStringResult()}",
                  },
                ),
              )),
            ],
          );
        },
      ),
    );
  }
}

class CaloryCellDetails extends StatelessWidget {
  final String title;
  const CaloryCellDetails(
    this.title, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailsStyle = theme(context).textTheme.labelLarge;
    return Text(
      title,
      style: detailsStyle,
      textAlign: TextAlign.center,
    );
  }
}

extension ToStringResult on num {
  String toStringResult() {
    final _num = round().toString();
    return _num;
  }
}
