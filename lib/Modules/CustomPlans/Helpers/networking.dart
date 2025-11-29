import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/CustomPlans/Days/Data/api_clients.dart' show DayExerciseDirection;

class CustomPlansNetworking {
  CustomPlansNetworking._();

  static Uri _myPlans = Network.clientUri.addSegment('/my/plans');
  static Uri _myPlanWeekDays = Network.clientUri.addSegment('/my/plan-week-days');

  static Uri myPlans([int? planID]) {
    if (planID != null) return _myPlans.addSegment('/$planID');
    return _myPlans;
  }

  static Uri planWeeks(int planID, [int? weekID]) {
    return myPlans(planID).addSegments(['/plan-weeks', if (weekID != null) '/$weekID']);
  }

  static Uri dayExercises(
    int dayID, {
    int? exerciseID,
    DayExerciseDirection? direction,
  }) {
    return _myPlanWeekDays.addSegments([
      '/$dayID',
      '/day-exercises',
      if (exerciseID != null) '/$exerciseID',
    ]).addQueryParams([
      if (direction != null)
        QueryParam(
          param: 'direction',
          value: direction.name,
        ),
    ]);
  }

  static Uri exerciseTypes() {
    return Network.clientUri.addSegment('/exercise-types');
  }
}
