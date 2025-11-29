// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleCategoriesResponse _$ArticleCategoriesResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ArticleCategoriesResponse',
      json,
      ($checkedConvert) {
        final val = ArticleCategoriesResponse(
          categories: $checkedConvert(
              'data',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      ArticleCategory.fromJson(e as Map<String, dynamic>))
                  .toList()),
          nextPageUrl: $checkedConvert('next_page_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'categories': 'data', 'nextPageUrl': 'next_page_url'},
    );

Map<String, dynamic> _$ArticleCategoriesResponseToJson(
        ArticleCategoriesResponse instance) =>
    <String, dynamic>{
      'data': instance.categories.map((e) => e.toJson()).toList(),
      'next_page_url': instance.nextPageUrl,
    };

ArticleCategory _$ArticleCategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ArticleCategory',
      json,
      ($checkedConvert) {
        final val = ArticleCategory(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          assets: $checkedConvert(
              'assets', (v) => ImageAsset.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ArticleCategoryToJson(ArticleCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'assets': instance.assets.toJson(),
    };
