import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:the_coach/Modules/Misc/models/models.dart';

part 'category.g.dart';

@JsonSerializable()
class ArticleCategoriesResponse extends Equatable {
  @JsonKey(name: "data")
  final List<ArticleCategory> categories;
  @JsonKey(name: "next_page_url")
  final String? nextPageUrl;

  const ArticleCategoriesResponse({
    required this.categories,
    this.nextPageUrl,
  });

  factory ArticleCategoriesResponse.fromJson(Map<String, dynamic> json) => _$ArticleCategoriesResponseFromJson(
        json['categories'],
      );

  @visibleForTesting
  Map<String, dynamic> toJson() => _$ArticleCategoriesResponseToJson(this);

  @override
  List<Object?> get props => [categories, nextPageUrl];

  ArticleCategoriesResponse copyWith({
    List<ArticleCategory>? categories,
    String? nextPageUrl,
  }) {
    return ArticleCategoriesResponse(
      categories: categories ?? this.categories,
      nextPageUrl: nextPageUrl,
    );
  }
}

@JsonSerializable()
class ArticleCategory extends Equatable {
  final int id;
  final String name;

  final ImageAsset assets;

  const ArticleCategory({
    required this.id,
    required this.name,
    required this.assets,
  });

  factory ArticleCategory.fromJson(Map<String, dynamic> json) => _$ArticleCategoryFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$ArticleCategoryToJson(this);

  @override
  List<Object> get props => [id, name, assets];
}
