import 'package:json_annotation/json_annotation.dart';

part 'wallpaper_entity.g.dart';

@JsonSerializable()
class WallpaperListing {
  WallpaperListing({required this.after, required this.children});

  factory WallpaperListing.fromJson(Map<String, dynamic> json) =>
      _$WallpaperListingFromJson(json);

  Map<String, dynamic> toJson() => _$WallpaperListingToJson(this);

  final String? after;
  final List<WallpaperEntity> children;
}

@JsonSerializable()
class WallpaperEntity {
  WallpaperEntity({
    required this.kind,
    required this.data,
  });

  factory WallpaperEntity.fromJson(Map<String, dynamic> json) =>
      _$WallpaperEntityFromJson(json);
  @JsonKey(name: 'kind')
  final String kind;
  @JsonKey(name: 'data')
  final WallpaperData data;

  Map<String, dynamic> toJson() => _$WallpaperEntityToJson(this);
}

@JsonSerializable()
class WallpaperData {
  WallpaperData({
    required this.subredditNamePrefixed,
    required this.upvoteRatio,
    required this.ups,
    required this.author,
    required this.permalink,
    required this.createdUtc,
    this.preview,
    this.mediaMetadata,
    this.galleryData,
  });

  factory WallpaperData.fromJson(Map<String, dynamic> json) =>
      _$WallpaperDataFromJson(json);
  @JsonKey(name: 'subreddit_name_prefixed')
  final String subredditNamePrefixed;
  @JsonKey(name: 'upvote_ratio')
  final double upvoteRatio;
  @JsonKey(name: 'ups')
  final int ups;
  @JsonKey(name: 'preview')
  final Preview? preview;
  @JsonKey(name: 'author')
  final String author;
  @JsonKey(name: 'permalink')
  final String permalink;
  @JsonKey(name: 'created_utc')
  final int createdUtc;
  @JsonKey(name: 'media_metadata')
  final Map<String, MediaMetadatum>? mediaMetadata;
  @JsonKey(name: 'gallery_data')
  final GalleryData? galleryData;

  Map<String, dynamic> toJson() => _$WallpaperDataToJson(this);
}

@JsonSerializable()
class GalleryData {
  GalleryData({
    required this.items,
  });

  factory GalleryData.fromJson(Map<String, dynamic> json) =>
      _$GalleryDataFromJson(json);
  @JsonKey(name: 'items')
  final List<Item> items;

  Map<String, dynamic> toJson() => _$GalleryDataToJson(this);
}

@JsonSerializable()
class Item {
  Item({
    required this.mediaId,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  @JsonKey(name: 'media_id')
  final String mediaId;

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class MediaMetadatum {
  MediaMetadatum({
    this.p,
    this.s,
  });

  factory MediaMetadatum.fromJson(Map<String, dynamic> json) =>
      _$MediaMetadatumFromJson(json);
  @JsonKey(name: 'p')
  final List<S>? p;
  @JsonKey(name: 's')
  final S? s;

  Map<String, dynamic> toJson() => _$MediaMetadatumToJson(this);
}

@JsonSerializable()
class S {
  S({
    required this.y,
    required this.x,
    required this.u,
  });

  factory S.fromJson(Map<String, dynamic> json) {
    return S(
      y: json['y'] as int,
      x: json['x'] as int,
      u: json.containsKey('u') ? json['u'] as String : json['gif'] as String,
    );
  }

  final int y;
  final int x;
  final String u;
}

@JsonSerializable()
class Preview {
  Preview({
    required this.images,
  });

  factory Preview.fromJson(Map<String, dynamic> json) =>
      _$PreviewFromJson(json);
  @JsonKey(name: 'images')
  final List<Image> images;

  Map<String, dynamic> toJson() => _$PreviewToJson(this);
}

@JsonSerializable()
class Image {
  Image({
    this.source,
    this.resolutions,
  });

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  @JsonKey(name: 'source')
  final Source? source;
  @JsonKey(name: 'resolutions')
  final List<Source>? resolutions;

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}

@JsonSerializable()
class Source {
  Source({
    required this.width,
    required this.height,
    required this.url,
  });

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'width')
  final int width;
  @JsonKey(name: 'height')
  final int height;

  Map<String, dynamic> toJson() => _$SourceToJson(this);
}
