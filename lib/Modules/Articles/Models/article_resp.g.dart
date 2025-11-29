// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticlesResponse _$ArticlesResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ArticlesResponse',
      json,
      ($checkedConvert) {
        final val = ArticlesResponse(
          articles: $checkedConvert(
              'data',
              (v) => (v as List<dynamic>)
                  .map((e) => Article.fromJson(e as Map<String, dynamic>))
                  .toList()),
          nextPageUrl: $checkedConvert('next_page_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'articles': 'data', 'nextPageUrl': 'next_page_url'},
    );

Map<String, dynamic> _$ArticlesResponseToJson(ArticlesResponse instance) =>
    <String, dynamic>{
      'data': instance.articles.map((e) => e.toJson()).toList(),
      'next_page_url': instance.nextPageUrl,
    };

Article _$ArticleFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Article',
      json,
      ($checkedConvert) {
        final val = Article(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          title: $checkedConvert('title', (v) => v as String),
          body: $checkedConvert('body', (v) => v as String),
          assets: $checkedConvert(
              'assets', (v) => ImageAsset.fromJson(v as Map<String, dynamic>)),
          isFavorite:
              $checkedConvert('is_favorite', (v) => v as bool? ?? false),
          favoriteCount: $checkedConvert(
              'favorites_count', (v) => (v as num?)?.toInt() ?? 0),
          commentsCount: $checkedConvert(
              'comments_count', (v) => (v as num?)?.toInt() ?? 0),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'isFavorite': 'is_favorite',
        'favoriteCount': 'favorites_count',
        'commentsCount': 'comments_count',
        'createdAt': 'created_at'
      },
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'assets': instance.assets.toJson(),
      'is_favorite': instance.isFavorite,
      'favorites_count': instance.favoriteCount,
      'comments_count': instance.commentsCount,
      'created_at': instance.createdAt.toIso8601String(),
    };
