// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subreddit_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubredditListing _$SubredditListingFromJson(Map<String, dynamic> json) =>
    SubredditListing(
      after: json['after'] as String?,
      children: (json['children'] as List<dynamic>)
          .map((e) => SubredditEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubredditListingToJson(SubredditListing instance) =>
    <String, dynamic>{
      'after': instance.after,
      'children': instance.children,
    };

SubredditEntity _$SubredditEntityFromJson(Map<String, dynamic> json) =>
    SubredditEntity(
      kind: json['kind'] as String,
      data: SubredditData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SubredditEntityToJson(SubredditEntity instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'data': instance.data,
    };

SubredditData _$SubredditDataFromJson(Map<String, dynamic> json) =>
    SubredditData(
      displayNamePrefixed: json['display_name_prefixed'] as String,
      subscribers: (json['subscribers'] as num?)?.toInt() ?? 0,
      iconImg: json['icon_img'] as String? ?? '',
      bannerBackgroundImage: json['banner_background_image'] as String? ?? '',
      primaryColor: json['primary_color'] as String?,
      publicDescription: json['public_description'] as String?,
    );

Map<String, dynamic> _$SubredditDataToJson(SubredditData instance) =>
    <String, dynamic>{
      'display_name_prefixed': instance.displayNamePrefixed,
      'icon_img': instance.iconImg,
      'subscribers': instance.subscribers,
      'primary_color': instance.primaryColor,
      'public_description': instance.publicDescription,
      'banner_background_image': instance.bannerBackgroundImage,
    };
