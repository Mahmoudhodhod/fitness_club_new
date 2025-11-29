import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exercise_type.g.dart';

@JsonSerializable(createToJson: false)
class ExerciseTypesResponse extends Equatable {
  @JsonKey(name: "exercise_types")
  final List<ExerciseType> types;

  const ExerciseTypesResponse({required this.types});

  factory ExerciseTypesResponse.fromJson(Map<String, dynamic> json) => _$ExerciseTypesResponseFromJson(json);

  @override
  List<Object> get props => [types];
}

@JsonSerializable(createToJson: false)
class ExerciseType extends Equatable {
  final int id;
  final String title;

  @JsonKey(defaultValue: 1)
  final int maxExercisesCount;

  const ExerciseType({
    required this.id,
    required this.title,
    required this.maxExercisesCount,
  });

  factory ExerciseType.fromJson(Map<String, dynamic> json) => _$ExerciseTypeFromJson(json);

  @override
  List<Object> get props => [id, title, maxExercisesCount];
}
