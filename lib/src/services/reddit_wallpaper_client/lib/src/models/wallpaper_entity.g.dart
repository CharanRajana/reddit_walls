// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallpaperListing _$WallpaperListingFromJson(Map<String, dynamic> json) =>
    WallpaperListing(
      after: json['after'] as String?,
      children: (json['children'] as List<dynamic>)
          .map((e) => WallpaperEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WallpaperListingToJson(WallpaperListing instance) =>
    <String, dynamic>{
      'after': instance.after,
      'children': instance.children,
    };

WallpaperEntity _$WallpaperEntityFromJson(Map<String, dynamic> json) =>
    WallpaperEntity(
      kind: json['kind'] as String,
      data: WallpaperData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WallpaperEntityToJson(WallpaperEntity instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'data': instance.data,
    };

WallpaperData _$WallpaperDataFromJson(Map<String, dynamic> json) =>
    WallpaperData(
      subredditNamePrefixed: json['subreddit_name_prefixed'] as String,
      upvoteRatio: (json['upvote_ratio'] as num).toDouble(),
      ups: (json['ups'] as num).toInt(),
      author: json['author'] as String,
      permalink: json['permalink'] as String,
      createdUtc: (json['created_utc'] as num).toInt(),
      preview: json['preview'] == null
          ? null
          : Preview.fromJson(json['preview'] as Map<String, dynamic>),
      mediaMetadata: (json['media_metadata'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, MediaMetadatum.fromJson(e as Map<String, dynamic>)),
      ),
      galleryData: json['gallery_data'] == null
          ? null
          : GalleryData.fromJson(json['gallery_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WallpaperDataToJson(WallpaperData instance) =>
    <String, dynamic>{
      'subreddit_name_prefixed': instance.subredditNamePrefixed,
      'upvote_ratio': instance.upvoteRatio,
      'ups': instance.ups,
      'preview': instance.preview,
      'author': instance.author,
      'permalink': instance.permalink,
      'created_utc': instance.createdUtc,
      'media_metadata': instance.mediaMetadata,
      'gallery_data': instance.galleryData,
    };

GalleryData _$GalleryDataFromJson(Map<String, dynamic> json) => GalleryData(
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GalleryDataToJson(GalleryData instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      mediaId: json['media_id'] as String,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'media_id': instance.mediaId,
    };

MediaMetadatum _$MediaMetadatumFromJson(Map<String, dynamic> json) =>
    MediaMetadatum(
      p: (json['p'] as List<dynamic>?)
          ?.map((e) => S.fromJson(e as Map<String, dynamic>))
          .toList(),
      s: json['s'] == null
          ? null
          : S.fromJson(json['s'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MediaMetadatumToJson(MediaMetadatum instance) =>
    <String, dynamic>{
      'p': instance.p,
      's': instance.s,
    };

S _$SFromJson(Map<String, dynamic> json) => S(
      y: (json['y'] as num).toInt(),
      x: (json['x'] as num).toInt(),
      u: json['u'] as String,
    );

Map<String, dynamic> _$SToJson(S instance) => <String, dynamic>{
      'y': instance.y,
      'x': instance.x,
      'u': instance.u,
    };

Preview _$PreviewFromJson(Map<String, dynamic> json) => Preview(
      images: (json['images'] as List<dynamic>)
          .map((e) => Image.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PreviewToJson(Preview instance) => <String, dynamic>{
      'images': instance.images,
    };

Image _$ImageFromJson(Map<String, dynamic> json) => Image(
      source: json['source'] == null
          ? null
          : Source.fromJson(json['source'] as Map<String, dynamic>),
      resolutions: (json['resolutions'] as List<dynamic>?)
          ?.map((e) => Source.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'source': instance.source,
      'resolutions': instance.resolutions,
    };

Source _$SourceFromJson(Map<String, dynamic> json) => Source(
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$SourceToJson(Source instance) => <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };
