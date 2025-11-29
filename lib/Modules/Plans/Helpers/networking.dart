import 'package:utilities/utilities.dart';

class PlansNetworking {
  static Uri get planCategories {
    return Network.clientUri.addSegment('/plan-categories');
  }

  static Uri _plansUri = Network.clientUri.addSegment('/plans');

  static Uri plan({String? query, String? categoryID}) {
    if (query != null) {
      return _plansUri.addQueryParams(
        [QueryParam(param: 'search', value: query)],
      );
    }
    return _plansUri.addQueryParams(
      [QueryParam(param: 'plan_category_id', value: categoryID)],
    );
  }

  static Uri planWeeks(int planID) {
    return _plansUri.addSegments(['/$planID/', 'plan-weeks']);
  }

  static Uri dayExercise(int dayID) {
    return Network.clientUri.addSegments(['/day-exercises', '/$dayID']);
  }
}
