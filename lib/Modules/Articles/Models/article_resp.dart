import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:the_coach/Modules/Misc/models/models.dart';

part 'article_resp.g.dart';

@JsonSerializable()
class ArticlesResponse extends Equatable {
  @JsonKey(name: "data")
  final List<Article> articles;
  @JsonKey(name: "next_page_url")
  final String? nextPageUrl;

  const ArticlesResponse({
    required this.articles,
    this.nextPageUrl,
  });

  factory ArticlesResponse.fromJson(Map<String, dynamic> json) => _$ArticlesResponseFromJson(json['articles']);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$ArticlesResponseToJson(this);

  @override
  List<Object?> get props => [articles, nextPageUrl];

  ArticlesResponse copyWith({
    List<Article>? articles,
    String? nextPageUrl,
  }) {
    return ArticlesResponse(
      articles: articles ?? this.articles,
      nextPageUrl: nextPageUrl,
    );
  }
}

@JsonSerializable()
class Article extends Equatable {
  final int id;

  final String title;

  final String body;

  final ImageAsset assets;

  @JsonKey(name: "is_favorite", defaultValue: false)
  final bool isFavorite;

  @JsonKey(name: "favorites_count", defaultValue: 0)
  final int favoriteCount;

  @JsonKey(name: "comments_count", defaultValue: 0)
  final int commentsCount;

  @JsonKey(name: "created_at")
  final DateTime createdAt;

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  Article({
    required this.id,
    required this.title,
    required this.body,
    required this.assets,
    required this.isFavorite,
    required this.favoriteCount,
    required this.commentsCount,
    required this.createdAt,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      body,
      assets,
      isFavorite,
      favoriteCount,
      commentsCount,
      createdAt,
    ];
  }
}
