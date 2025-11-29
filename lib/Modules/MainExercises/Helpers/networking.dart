import 'package:utilities/utilities.dart';

class PowerTrainingNetworking {
  //? {{url}}/ar/api/client/main-exercises

  static Uri _mainExerciseUri = Network.clientUri.addSegment('/main-exercises');

  static Uri mainExerciseCategories({String? query}) {
    return Network.clientUri.addSegment('/main-exercise-categories').addQueryParams([
      if (query != null) QueryParam(param: 'search', value: query),
    ]);
  }

  static Uri mainExercisesUri({int? categoryId, String? query, bool? favorite}) {
    return _mainExerciseUri.addQueryParams([
      if (categoryId != null)
        QueryParam(
          param: 'main_exercise_category_id',
          value: categoryId,
        ),
      if (query != null)
        QueryParam(
          param: 'search',
          value: query,
        ),
      if (favorite != null)
        QueryParam(
          param: 'is_favorite',
          value: '$favorite',
        ),
    ]);
  }

  static Uri exercisePartsUri(int exerciseID) {
    return _mainExerciseUri.addSegments(["/$exerciseID/", "exercise-parts"]);
  }

  static mainExerciseById(int id) => _mainExerciseUri.addSegments(["/$id"]);
}
