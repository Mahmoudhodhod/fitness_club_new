import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:the_coach/Modules/Misc/models/models.dart';

part 'main_exercise.g.dart';

@JsonSerializable()
class MainExercisesResponse extends Equatable {
  @JsonKey(name: "data")
  final List<MainExercise> exercises;

  final String? nextPageUrl;

  const MainExercisesResponse({
    required this.exercises,
    this.nextPageUrl,
  });

  factory MainExercisesResponse.fromJson(Map<String, dynamic> json) => _$MainExercisesResponseFromJson(
        json['main_exercises'],
      );

  @visibleForTesting
  Map<String, dynamic> toJson() => _$MainExercisesResponseToJson(this);

  @override
  List<Object?> get props => [exercises, nextPageUrl];
}

@JsonSerializable()
class MainExercise extends Equatable {
  final int id;

  final String name;

  @JsonKey(name: "power_rating", defaultValue: 0)
  final int rating;

  @JsonKey(name: "exercise_parts_count")
  final int parts;

  @JsonKey(defaultValue: false)
  final bool isFavorite;

  final int favoritesCount;

  final String content;

  final ImageAsset assets;

  const MainExercise({
    required this.id,
    required this.name,
    required this.rating,
    required this.parts,
    required this.isFavorite,
    required this.favoritesCount,
    required this.content,
    required this.assets,
  });

  factory MainExercise.fromJson(Map<String, dynamic> json) => _$MainExerciseFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$MainExerciseToJson(this);

  @override
  List<Object> get props {
    return [
      id,
      name,
      rating,
      parts,
      isFavorite,
      favoritesCount,
      content,
      assets,
    ];
  }
}
