import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:the_coach/Modules/Muscles/muscles_module.dart';

import 'exercise_type.dart';

part 'exercise_day.g.dart';

@JsonSerializable(createToJson: false)
class DayExercisesResponse extends Equatable {
  @JsonKey(name: 'day_exercises')
  final List<DayExercise> days;

  const DayExercisesResponse({
    required this.days,
  });

  factory DayExercisesResponse.fromJson(Map<String, dynamic> json) => _$DayExercisesResponseFromJson(json);

  @override
  List<Object> get props => [days];
}

@JsonSerializable(createToJson: false)
class DayExercise extends Equatable {
  final int id;

  @JsonKey(defaultValue: 0)
  final int sets;

  @JsonKey(defaultValue: '-')
  final String reps;

  @JsonKey(defaultValue: 0)
  final int? restDuration;

  @JsonKey(defaultValue: '')
  final String? plan;

  final String? videoUrl;

  final ExerciseType? exerciseType;

  @JsonKey(name: 'sub_exercises')
  final List<SubExercise> exercises;

  factory DayExercise.fromJson(Map<String, dynamic> json) => _$DayExerciseFromJson(json);

  ///Is the current model has a video exercise in it?
  ///
  bool get isVideoExercise => videoUrl != null;
  bool get isNotVideoExercise => !isVideoExercise;

  bool get hasEmptyExercises => exercises.isEmpty;

  bool get hasMultipleExercises => exercises.length > 1;

  const DayExercise({
    required this.id,
    required this.sets,
    required this.reps,
    required this.exercises,
    this.exerciseType,
    this.plan,
    this.restDuration,
    this.videoUrl,
  });

  @override
  List<Object?> get props {
    return [
      id,
      sets,
      reps,
      restDuration,
      plan,
      exercises,
      videoUrl,
    ];
  }
}
