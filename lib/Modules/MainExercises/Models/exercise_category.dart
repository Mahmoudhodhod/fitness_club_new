import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:json_annotation/json_annotation.dart';

import 'package:the_coach/Modules/Misc/models/models.dart';

part 'exercise_category.g.dart';

@JsonSerializable()
class MainExercisesCategoriesResponse extends Equatable {
  @JsonKey(name: 'main_exercise_categories')
  final List<MainExercisesCategory> categories;

  const MainExercisesCategoriesResponse({required this.categories});

  factory MainExercisesCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$MainExercisesCategoriesResponseFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$MainExercisesCategoriesResponseToJson(this);

  @override
  List<Object> get props => [categories];
}

@JsonSerializable()
class MainExercisesCategory extends Equatable {
  final int id;
  final String name;

  final ImageAsset assets;

  const MainExercisesCategory({
    required this.id,
    required this.name,
    required this.assets,
  });

  factory MainExercisesCategory.fromJson(Map<String, dynamic> json) => _$MainExercisesCategoryFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$MainExercisesCategoryToJson(this);

  @override
  List<Object> get props => [id, name, assets];

  @override
  bool? get stringify => true;
}
