import 'package:flutter_test/flutter_test.dart';
import 'package:utilities/utilities.dart';

void main() {
  group("const PostAction", () {
    group("supports value comparison", () {
      test("supports direct value comparison", () {
        expect(
          const PostAction(action: Action.article, modelID: 5, data: {}),
          const PostAction(action: Action.article, modelID: 5, data: {}),
        );
      });

      test("returns an object with [Action.article] action", () {
        expect(
          const PostAction.article(modelID: 5, data: {}),
          const PostAction(action: Action.article, modelID: 5, data: {}),
        );
      });

      test("returns an object with [Action.mainExercise] action", () {
        expect(
          const PostAction.mainExercise(modelID: 2, data: {}),
          const PostAction(action: Action.mainExercise, modelID: 2, data: {}),
        );
      });

      test("returns an object with [Action.subExercise] action", () {
        expect(
          const PostAction.subExercise(modelID: 20, data: {}),
          const PostAction(action: Action.subExercise, modelID: 20, data: {}),
        );
      });
    });

    group("toJson()", () {
      test("retruns only [action] and [modelID]", () {
        expect(
          const PostAction.article(modelID: 20).toJson(),
          {"model_id": 20, "model": 'article'},
        );
      });
      test("retruns ginen [data] combinded with [action] and [modelID]", () {
        expect(
          const PostAction.subExercise(modelID: 12, data: {"comment": 'this is a comment'}).toJson(),
          {"model_id": 12, "model": 'sub_exercise', "comment": 'this is a comment'},
        );
      });
    });

    test("toQueryParams()", () {
      expect(
        const PostAction(modelID: 5, action: Action.article).toQueryParams(),
        [
          const QueryParam(param: 'model', value: 'article'),
          const QueryParam(param: 'model_id', value: '5'),
        ],
      );
    });
  });
}
