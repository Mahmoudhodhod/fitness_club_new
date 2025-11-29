import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:utilities/utilities.dart';

part 'post_action.g.dart';

enum Action {
  article,
  @JsonValue("main_exercise")
  mainExercise,
  @JsonValue("sub_exercise")
  subExercise,
}

@JsonSerializable()
class PostAction extends Equatable {
  @JsonKey(name: "model")
  final Action action;

  @JsonKey(name: "model_id")
  final int modelID;

  @JsonKey(ignore: true)
  final Map<String, dynamic>? data;

  const PostAction({
    required this.modelID,
    required this.action,
    this.data,
  });

  const PostAction.article({
    required this.modelID,
    this.data,
  }) : action = Action.article;

  const PostAction.mainExercise({
    required this.modelID,
    this.data,
  }) : action = Action.mainExercise;

  const PostAction.subExercise({
    required this.modelID,
    this.data,
  }) : action = Action.subExercise;

  Map<String, dynamic> _toJson() => _$PostActionToJson(this);

  @visibleForTesting
  factory PostAction.test(Map<String, dynamic> json) => _$PostActionFromJson(json);

  Map<String, dynamic> toJson() {
    return mergeMaps([
      _toJson(),
      data ?? {},
    ]);
  }

  @override
  List<Object?> get props => [action, modelID, data];

  List<QueryParam> toQueryParams() {
    final list = <QueryParam>[];
    _toJson().forEach((key, value) {
      final qParam = QueryParam(param: key, value: value.toString());
      list.add(qParam);
    });
    return list;
  }
}
