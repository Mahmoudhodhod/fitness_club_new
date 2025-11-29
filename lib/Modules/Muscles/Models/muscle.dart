import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:the_coach/Modules/Misc/models/models.dart';

part 'muscle.g.dart';

@JsonSerializable()
class MusclesResponse extends Equatable {
  @JsonKey(name: "muscle_exercises")
  final List<Muscle> muscles;

  const MusclesResponse({
    required this.muscles,
  });

  factory MusclesResponse.fromJson(Map<String, dynamic> json) => _$MusclesResponseFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$MusclesResponseToJson(this);

  @override
  List<Object?> get props => [muscles];
}

@JsonSerializable()
class Muscle extends Equatable {
  final int id;

  final String name;

  final ImageAsset assets;

  const Muscle({
    required this.id,
    required this.name,
    required this.assets,
  });

  factory Muscle.fromJson(Map<String, dynamic> json) => _$MuscleFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$MuscleToJson(this);

  @override
  List<Object> get props => [id, name, assets];
}
