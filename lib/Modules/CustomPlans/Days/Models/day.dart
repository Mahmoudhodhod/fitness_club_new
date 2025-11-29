import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'day.g.dart';

@JsonSerializable()
class NewDayExercise extends Equatable {
  final int sets;
  final String reps;
  final int? restDuration;
  final String? plan;

  @JsonKey(name: 'exercise_type_id')
  final int exerciseTypeId;

  @JsonKey(name: 'sub_exercise_ids')
  final List<int> subexercisesIds;

  const NewDayExercise({
    required this.sets,
    required this.reps,
    required this.restDuration,
    required this.plan,
    required this.exerciseTypeId,
    required this.subexercisesIds,
  });

  @visibleForTesting
  factory NewDayExercise.fromJson(Map<String, dynamic> json) => _$NewDayExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$NewDayExerciseToJson(this);

  @override
  List<Object?> get props {
    return [
      sets,
      reps,
      restDuration,
      plan,
      exerciseTypeId,
      subexercisesIds,
    ];
  }

  @override
  bool? get stringify => true;
}
