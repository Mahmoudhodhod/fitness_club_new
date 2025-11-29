// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentsResponse _$CommentsResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CommentsResponse',
      json,
      ($checkedConvert) {
        final val = CommentsResponse(
          comments: $checkedConvert(
              'data',
              (v) => (v as List<dynamic>)
                  .map((e) => Comment.fromJson(e as Map<String, dynamic>))
                  .toList()),
          nextPageUrl: $checkedConvert('next_page_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'comments': 'data', 'nextPageUrl': 'next_page_url'},
    );

Map<String, dynamic> _$CommentsResponseToJson(CommentsResponse instance) =>
    <String, dynamic>{
      'data': instance.comments.map((e) => e.toJson()).toList(),
      'next_page_url': instance.nextPageUrl,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Comment',
      json,
      ($checkedConvert) {
        final val = Comment(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          content: $checkedConvert('comment', (v) => v as String),
          user: $checkedConvert(
              'user', (v) => CommentAuthor.fromJson(v as Map<String, dynamic>)),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {'content': 'comment', 'createdAt': 'created_at'},
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'comment': instance.content,
      'user': instance.user.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
    };

CommentAuthor _$CommentAuthorFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CommentAuthor',
      json,
      ($checkedConvert) {
        final val = CommentAuthor(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          image: $checkedConvert('image', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$CommentAuthorToJson(CommentAuthor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
