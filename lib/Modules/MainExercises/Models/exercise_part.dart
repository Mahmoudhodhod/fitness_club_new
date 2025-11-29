import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:the_coach/Modules/Muscles/muscles_module.dart' show SubExercise;
import 'package:the_coach/Modules/Plans/plans_module.dart' show ExerciseType;

part 'exercise_part.g.dart';

@JsonSerializable(createToJson: false)
class PartsResponse extends Equatable {
  @JsonKey(name: "exercise_parts")
  final List<ExercisePart> parts;

  const PartsResponse({
    required this.parts,
  });

  factory PartsResponse.fromJson(Map<String, dynamic> json) => _$PartsResponseFromJson(json);

  @override
  List<Object> get props => [parts];
}

@JsonSerializable(createToJson: false)
class ExercisePart extends Equatable {
  final int id;
  final String name;
  final String plan;
  final int sets;
  final String reps;
  final int restDuration;
  final ExerciseType exerciseType;

  final SubExercise subExercise;

  const ExercisePart({
    required this.id,
    required this.name,
    required this.plan,
    required this.sets,
    required this.reps,
    required this.restDuration,
    required this.exerciseType,
    required this.subExercise,
  });

  factory ExercisePart.fromJson(Map<String, dynamic> json) => _$ExercisePartFromJson(json);

  @override
  List<Object> get props {
    return [
      id,
      name,
      plan,
      sets,
      reps,
      restDuration,
      exerciseType,
      subExercise,
    ];
  }
}
