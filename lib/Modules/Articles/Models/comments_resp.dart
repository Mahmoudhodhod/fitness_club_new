import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide AssetImage;
import 'package:json_annotation/json_annotation.dart';

part 'comments_resp.g.dart';

@JsonSerializable()
class CommentsResponse extends Equatable {
  @JsonKey(name: "data")
  final List<Comment> comments;
  @JsonKey(name: "next_page_url")
  final String? nextPageUrl;

  const CommentsResponse({
    required this.comments,
    this.nextPageUrl,
  });

  factory CommentsResponse.fromJson(Map<String, dynamic> json) => _$CommentsResponseFromJson(
        json['comments'],
      );

  @visibleForTesting
  Map<String, dynamic> toJson() => _$CommentsResponseToJson(this);

  @override
  List<Object?> get props => [comments, nextPageUrl];
}

@JsonSerializable()
class Comment extends Equatable {
  final int id;
  @JsonKey(name: "comment")
  final String content;

  @JsonKey(name: 'user')
  final CommentAuthor user;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.content,
    required this.user,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  List<Object?> get props => [id, content, user, createdAt];

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class CommentAuthor extends Equatable {
  final int id;
  final String name;

  final String image;

  const CommentAuthor({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CommentAuthor.fromJson(Map<String, dynamic> json) => _$CommentAuthorFromJson(json);

  @visibleForTesting
  Map<String, dynamic> toJson() => _$CommentAuthorToJson(this);

  @override
  List<Object> get props => [id, name, image];

  @override
  bool? get stringify => true;
}
