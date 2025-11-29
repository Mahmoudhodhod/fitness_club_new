import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

@immutable
class CaloriesRowViewModel {
  final String title;
  final double result;
  const CaloriesRowViewModel({
    required this.title,
    required this.result,
  });
}

@immutable
class CaloriesResult extends Equatable {
  ///the required calories to mentain the current weight.
  ///
  final double? toMaintainWeight;

  ///the required calories to loss 0.5 KG of the current weight
  ///per week.
  ///
  final double? toLossHalfKGPerWeek;

  ///the required calories to loss 1 KG of the current weight
  ///per week.
  ///
  final double? toLossKGPerWeek;

  ///the required calories to gain 0.5 KG to the current weight
  ///per week.
  ///
  final double? toGainHalfKGPerWeek;

  ///the required calories to gain 1 KG to the current weight
  ///per week.
  ///
  final double? toGainKGPerWeek;
  const CaloriesResult({
    this.toMaintainWeight,
    this.toLossHalfKGPerWeek,
    this.toLossKGPerWeek,
    this.toGainHalfKGPerWeek,
    this.toGainKGPerWeek,
  });

  @override
  List<Object?> get props {
    return [
      toMaintainWeight,
      toLossHalfKGPerWeek,
      toLossKGPerWeek,
      toGainHalfKGPerWeek,
      toGainKGPerWeek,
    ];
  }

  @override
  bool? get stringify => true;
}

///Creates a table which displays the calories information the user need to
///get weekly to achieve his goal.
///
///The table is feed with data using [dataSource] which has
///the required calories to consume.
///
class CaloriesResultTable extends StatelessWidget {
  ///The table data source.
  ///
  final CaloriesResult dataSource;

  ///Creates a table which displays the calories information the user need to
  ///get weekly to achieve his goal.
  ///
  const CaloriesResultTable({
    Key? key,
    required this.dataSource,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _data = [
      CaloriesRowViewModel(
        title: LocaleKeys.screens_utilities_calculators_calories_calc_result_cal_to_mentain.tr(),
        result: dataSource.toMaintainWeight!,
      ),
      CaloriesRowViewModel(
        title: calToLossPerWeek(0.5),
        result: dataSource.toLossHalfKGPerWeek!,
      ),
      CaloriesRowViewModel(
        title: calToLossPerWeek(1),
        result: dataSource.toLossKGPerWeek!,
      ),
      CaloriesRowViewModel(
        title: calToGainPerWeek(0.5),
        result: dataSource.toGainHalfKGPerWeek!,
      ),
      CaloriesRowViewModel(
        title: calToGainPerWeek(1),
        result: dataSource.toGainKGPerWeek!,
      ),
    ];
    return FlexibleDataTable(
      dataRowPadding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 13.0),
      columns: [
        DataColumn(label: Text(LocaleKeys.screens_utilities_general_goal.tr())),
        const DataColumn(label: Text('')),
      ],
      rows: List.generate(
        _data.length,
        (index) {
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
              DataCell(CaloryCellDetails(LocaleKeys.screens_utilities_general_units_calory_num.tr(
                namedArgs: {
                  'num': (result.round()).toString(),
                },
              ))),
            ],
          );
        },
      ),
    );
  }

  static String calToLossPerWeek(double weight) {
    return LocaleKeys.screens_utilities_calculators_calories_calc_result_calo_loss_per_day.tr(namedArgs: {
      "num": weight.toDynamicFixedOnePoint(),
    });
  }

  static String calToGainPerWeek(double weight) {
    return LocaleKeys.screens_utilities_calculators_calories_calc_result_calo_gain_per_day.tr(namedArgs: {
      "num": weight.toDynamicFixedOnePoint(),
    });
  }
}
