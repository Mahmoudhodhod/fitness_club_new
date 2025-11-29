import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:the_coach/Modules/Misc/models/models.dart';

part 'plan.g.dart';

@JsonSerializable()
class PlansResponse extends Equatable {
  @JsonKey(name: "data")
  final List<Plan> plans;

  @JsonKey(name: "next_page_url")
  final String? nextPageUrl;

  const PlansResponse({
    required this.plans,
    required this.nextPageUrl,
  });

  factory PlansResponse.fromJson(Map<String, dynamic> json) => _$PlansResponseFromJson(
        json['plans'],
      );

  @visibleForTesting
  Map<String, dynamic> toJson() => _$PlansResponseToJson(this);

  @override
  List<Object?> get props => [plans, nextPageUrl];
}

@JsonSerializable()
class Plan extends Equatable {
  final int id;
  final String name;
  final String description;

  @JsonKey(name: 'plan_weeks_count', defaultValue: 0)
  final int weeksCount;

  final ImageAsset? assets;

  const Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.weeksCount,
    this.assets,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$PlanToJson(this);

  factory Plan.empty() {
    return const Plan(
      id: -1,
      name: '',
      description: '',
      weeksCount: -1,
      assets: ImageAsset.empty(),
    );
  }

  bool get isEmpty => this == Plan.empty();

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      weeksCount,
      assets,
    ];
  }
}
