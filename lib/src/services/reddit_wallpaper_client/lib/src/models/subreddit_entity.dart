import 'package:json_annotation/json_annotation.dart';

part 'subreddit_entity.g.dart';

@JsonSerializable()
class SubredditListing {
  SubredditListing({required this.after, required this.children});

  factory SubredditListing.fromJson(Map<String, dynamic> json) =>
      _$SubredditListingFromJson(json);

  Map<String, dynamic> toJson() => _$SubredditListingToJson(this);

  final String? after;
  final List<SubredditEntity> children;
}

@JsonSerializable()
class SubredditEntity {
  SubredditEntity({
    required this.kind,
    required this.data,
  });

  factory SubredditEntity.fromJson(Map<String, dynamic> json) =>
      _$SubredditEntityFromJson(json);
  @JsonKey(name: 'kind')
  final String kind;
  @JsonKey(name: 'data')
  final SubredditData data;

  Map<String, dynamic> toJson() => _$SubredditEntityToJson(this);
}

@JsonSerializable()
class SubredditData {
  SubredditData({
    required this.displayNamePrefixed,
    required this.subscribers,
    required this.iconImg,
    required this.bannerBackgroundImage,
    this.primaryColor,
    this.publicDescription,
  });

  factory SubredditData.fromJson(Map<String, dynamic> json) =>
      _$SubredditDataFromJson(json);
  @JsonKey(name: 'display_name_prefixed')
  final String displayNamePrefixed;
  @JsonKey(name: 'icon_img', defaultValue: '')
  final String iconImg;
  @JsonKey(name: 'subscribers', defaultValue: 0)
  final int subscribers;
  @JsonKey(name: 'primary_color')
  final String? primaryColor;
  @JsonKey(name: 'public_description')
  final String? publicDescription;
  @JsonKey(name: 'banner_background_image', defaultValue: '')
  final String bannerBackgroundImage;

  Map<String, dynamic> toJson() => _$SubredditDataToJson(this);
}
