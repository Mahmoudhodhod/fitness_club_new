import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:the_coach/Modules/Misc/models/models.dart';

part 'sub_exercise.g.dart';

@JsonSerializable()
class SubExercisesResponse extends Equatable {
  @JsonKey(name: "data")
  final List<SubExercise> exercises;

  @JsonKey(name: "next_page_url", required: false)
  final String? nextPageUrl;

  SubExercisesResponse({
    required this.exercises,
    this.nextPageUrl,
  });

  factory SubExercisesResponse.fromJson(Map<String, dynamic> json) => _$SubExercisesResponseFromJson(
        json['sub_exercises'],
      );

  @visibleForTesting
  Map<String, dynamic> toJson() => _$SubExercisesResponseToJson(this);

  @override
  List<Object?> get props => [exercises, nextPageUrl];
}

@JsonSerializable()
class SubExercise extends Equatable {
  final int id;

  final String name;

  @JsonKey(name: "body_part")
  final String bodyPart;

  final String description;

  @JsonKey(required: false, defaultValue: [])
  final List<String> steps;

  final ImageAsset assets;

  @JsonKey(name: "is_favorite", defaultValue: false)
  final bool isFavorite;

  @JsonKey(name: "favorites_count", defaultValue: 0)
  final int favoriteCount;

  final SideMuscle primary;

  final SideMuscle secondary;

  SubExercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.description,
    required this.steps,
    required this.assets,
    required this.isFavorite,
    required this.favoriteCount,
    required this.primary,
    required this.secondary,
  });

  factory SubExercise.fromJson(Map<String, dynamic> json) => _$SubExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$SubExerciseToJson(this);

  @override
  List<Object> get props {
    return [
      id,
      name,
      bodyPart,
      description,
      steps,
      assets,
      isFavorite,
      favoriteCount,
      primary,
      secondary,
    ];
  }
}

@JsonSerializable()
class SideMuscle extends Equatable {
  @JsonKey(name: "title")
  final String name;

  final ImageAsset assets;

  const SideMuscle({
    required this.name,
    required this.assets,
  });

  factory SideMuscle.fromJson(Map<String, dynamic> json) => _$SideMuscleFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$SideMuscleToJson(this);

  @override
  List<Object> get props => [name, assets];
}
