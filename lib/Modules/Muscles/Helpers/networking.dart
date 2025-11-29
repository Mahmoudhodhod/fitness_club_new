import 'package:utilities/utilities.dart';

class MusclesNetworking {
  MusclesNetworking._();

  static Uri musclesUri = Network.clientUri.addSegment("/muscle-exercises");
  static Uri _subExercisesUri = Network.clientUri.addSegment("/sub-exercises");

  //* {{url}}/ar/api/client/sub-exercises?search=&muscle_exercise_id=1

  static Uri musclesSubExercisesUri([int? muscleID, String? query]) {
    return _subExercisesUri.addQueryParams([
      if (muscleID != null) QueryParam(param: 'muscle_exercise_id', value: '$muscleID'),
      if (query != null) QueryParam(param: 'search', value: '$query'),
    ]);
  }

  // fetch sub exercise with id
  static Uri subExerciseByIdUri(int id) => _subExercisesUri.addSegment("/$id");
}
