import 'package:the_coach/Widgets/widgets.dart' show CaloriesResult;

class NewFatController {
  FatResult calculateFromCaloriesResult({required CaloriesResult caloriesResult}) {
    return _calculateFatsResult(caloriesResult);
  }

  FatResult _calculateFatsResult(CaloriesResult calculatedDCN) {
    return FatResult(
      toMaintainWeight: _calculateResultRow(calculatedDCN.toMaintainWeight!),
      toGainHalfKGPerWeek: _calculateResultRow(calculatedDCN.toGainHalfKGPerWeek!),
      toGainKGPerWeek: _calculateResultRow(calculatedDCN.toGainKGPerWeek!),
      toLossHalfKGPerWeek: _calculateResultRow(calculatedDCN.toLossHalfKGPerWeek!),
      toLossKGPerWeek: _calculateResultRow(calculatedDCN.toLossKGPerWeek!),
    );
  }

  FatResultRow _calculateResultRow(double entry) {
    return FatResultRow(
      dcn: entry,
      range: ResultRowRange(
        twentyPresentDFA: _calculatedDCNFraction(entry, 20),
        thirtyFivePresentDFA: _calculatedDCNFraction(entry, 35),
      ),
    );
  }

  ///Result is in grams
  double _calculatedDCNFraction(double dcn, double percentage) {
    final fraction = percentage / 100;
    return (dcn * fraction) / 9;
  }
}

class FatResult {
  ///the required fats to mentain the current weight.
  ///
  final FatResultRow toMaintainWeight;

  ///the required fats to loss 0.5 KG of the current weight
  ///per week.
  ///
  final FatResultRow toLossHalfKGPerWeek;

  ///the required fats to loss 1 KG of the current weight
  ///per week.
  ///
  final FatResultRow toLossKGPerWeek;

  ///the required fats to gain 0.5 KG to the current weight
  ///per week.
  ///
  final FatResultRow toGainHalfKGPerWeek;

  ///the required fats to gain 1 KG to the current weight
  ///per week.
  ///
  final FatResultRow toGainKGPerWeek;

  const FatResult({
    required this.toMaintainWeight,
    required this.toLossHalfKGPerWeek,
    required this.toLossKGPerWeek,
    required this.toGainHalfKGPerWeek,
    required this.toGainKGPerWeek,
  });

  @override
  String toString() {
    return 'FatResult(toMaintainWeight: $toMaintainWeight, toLossHalfKGPerWeek: $toLossHalfKGPerWeek, toLossKGPerWeek: $toLossKGPerWeek, toGainHalfKGPerWeek: $toGainHalfKGPerWeek, toGainKGPerWeek: $toGainKGPerWeek)';
  }
}

class FatResultRow {
  final double dcn;
  final ResultRowRange range;

  const FatResultRow({
    required this.dcn,
    required this.range,
  });

  @override
  String toString() => 'FatResultRow(dcn: $dcn, range: $range)';
}

//? DFA: Daily fat allowance

class ResultRowRange {
  final double twentyPresentDFA;
  final double thirtyFivePresentDFA;

  const ResultRowRange({
    required this.twentyPresentDFA,
    required this.thirtyFivePresentDFA,
  });

  @override
  String toString() =>
      'ResultRowRange(twentyPersentDFA: $twentyPresentDFA, thirtyFivePersentDFA: $thirtyFivePresentDFA)';
}
