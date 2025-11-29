import 'package:the_coach/Widgets/widgets.dart' show CaloriesResult;

class CarbsCalculator {
  CarbResult calculateFromCaloriesResult({required CaloriesResult caloriesResult}) {
    return _calculateCarbResult(caloriesResult);
  }

  CarbResult _calculateCarbResult(CaloriesResult calculatedDCN) {
    return CarbResult(
      toMaintainWeight: _calculateResultRow(calculatedDCN.toMaintainWeight!),
      toGainHalfKGPerWeek: _calculateResultRow(calculatedDCN.toGainHalfKGPerWeek!),
      toGainKGPerWeek: _calculateResultRow(calculatedDCN.toGainKGPerWeek!),
      toLossHalfKGPerWeek: _calculateResultRow(calculatedDCN.toLossHalfKGPerWeek!),
      toLossKGPerWeek: _calculateResultRow(calculatedDCN.toLossKGPerWeek!),
    );
  }

  CarbResultRow _calculateResultRow(double entry) {
    return CarbResultRow(
      dcn: entry,
      fortyPresentDCN: _calculatedDCNFraction(entry, 40),
      fiftyPresentDCN: _calculatedDCNFraction(entry, 50),
    );
  }

  double _calculatedDCNFraction(double dcn, double percentage) {
    final fraction = percentage / 100;
    return (dcn * fraction) / 4;
  }
}

class CarbResult {
  ///the required calories to mentain the current weight.
  ///
  final CarbResultRow toMaintainWeight;

  ///the required calories to loss 0.5 KG of the current weight
  ///per week.
  ///
  final CarbResultRow toLossHalfKGPerWeek;

  ///the required calories to loss 1 KG of the current weight
  ///per week.
  ///
  final CarbResultRow toLossKGPerWeek;

  ///the required calories to gain 0.5 KG to the current weight
  ///per week.
  ///
  final CarbResultRow toGainHalfKGPerWeek;

  ///the required calories to gain 1 KG to the current weight
  ///per week.
  ///
  final CarbResultRow toGainKGPerWeek;

  const CarbResult({
    required this.toMaintainWeight,
    required this.toLossHalfKGPerWeek,
    required this.toLossKGPerWeek,
    required this.toGainHalfKGPerWeek,
    required this.toGainKGPerWeek,
  });

  @override
  String toString() {
    return 'CarbResult(toMaintainWeight: $toMaintainWeight, toLossHalfKGPerWeek: $toLossHalfKGPerWeek, toLossKGPerWeek: $toLossKGPerWeek, toGainHalfKGPerWeek: $toGainHalfKGPerWeek, toGainKGPerWeek: $toGainKGPerWeek)';
  }
}

class CarbResultRow {
  final double dcn;
  final double fortyPresentDCN;
  final double fiftyPresentDCN;

  const CarbResultRow({
    required this.dcn,
    required this.fortyPresentDCN,
    required this.fiftyPresentDCN,
  });

  @override
  String toString() => 'CarbResultRow(dcn: $dcn, fortyPersentDCN: $fortyPresentDCN, fiftyPersentDCN: $fiftyPresentDCN)';
}
