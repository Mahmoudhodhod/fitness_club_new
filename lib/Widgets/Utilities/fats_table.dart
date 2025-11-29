import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Utilities/new_fat_controller.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'calories_table.dart';
import 'carbs_table.dart';
import 'flexable_data_table.dart';

@immutable
class FatsRowViewModel {
  final String title;
  final FatResultRow result;
  const FatsRowViewModel({
    required this.title,
    required this.result,
  });
}

class FatsResultTable extends StatelessWidget {
  final FatResult result;
  const FatsResultTable({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _data = [
      FatsRowViewModel(
        title: LocaleKeys.screens_utilities_calculators_calories_calc_result_cal_to_mentain.tr(),
        result: result.toMaintainWeight,
      ),
      FatsRowViewModel(
        title: CaloriesResultTable.calToLossPerWeek(.5),
        result: result.toLossHalfKGPerWeek,
      ),
      FatsRowViewModel(
        title: CaloriesResultTable.calToLossPerWeek(1),
        result: result.toLossKGPerWeek,
      ),
      FatsRowViewModel(
        title: CaloriesResultTable.calToGainPerWeek(.5),
        result: result.toGainHalfKGPerWeek,
      ),
      FatsRowViewModel(
        title: CaloriesResultTable.calToGainPerWeek(1),
        result: result.toGainKGPerWeek,
      ),
    ];
    return FlexibleDataTable(
      columns: [
        DataColumn(label: Text(LocaleKeys.screens_utilities_general_goal.tr())),
        DataColumn(label: Text(LocaleKeys.screens_utilities_calculators_calories_calc_dcn.tr())),
        const DataColumn(label: Text("*(20-35%)")),
      ],
      rows: List.generate(_data.length, (index) {
        final model = _data[index];
        final result = model.result;
        return DataRow(
          color: MaterialStateProperty.resolveWith<Color>((_) {
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
            DataCell(
              CaloryCellDetails(
                LocaleKeys.screens_utilities_general_units_calory_num.tr(
                  namedArgs: {
                    'num': result.dcn.toStringResult(),
                  },
                ),
              ),
            ),
            DataCell(
              CaloryCellDetails(
                LocaleKeys.screens_utilities_general_units_g_num.tr(namedArgs: {
                  'num': result.range.toReadableString(),
                }),
              ),
            ),
          ],
        );
      }),
    );
  }
}

extension on ResultRowRange {
  String toReadableString() {
    return "${twentyPresentDFA.toStringResult()}-${thirtyFivePresentDFA.toStringResult()}";
  }
}
