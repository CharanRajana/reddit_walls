import 'package:reddit_walls/src/services/reddit_wallpaper_client/lib/reddit_wallpaper_client.dart';
import 'package:reddit_walls/src/services/wallpaper_repository/src/models/models.dart';
import 'package:reddit_walls/src/utils/extensions.dart';

class DataMapper {
  List<Wallpaper> wallpaperEntityToWallpaper(
    WallpaperEntity entity,
    Subreddit sub,
  ) {
    final data = entity.data;
    final subreddit = sub;
    final author = data.author;
    final upvotes = data.ups;
    final postUrl = 'https://www.reddit.com${data.permalink}';
    final rating = data.upvoteRatio;
    final created = DateTime.fromMillisecondsSinceEpoch(
      data.createdUtc * 1000,
      isUtc: true,
    );
    // If the entity has single wallpaper
    if (data.preview != null) {
      final preview = data.preview!;

      if (preview.images.first.source != null &&
          preview.images.first.resolutions != null) {
        //Images
        final originalImageUrl = preview.images.first.source!.url;
        final width = preview.images.first.source!.width;
        final height = preview.images.first.source!.height;
        final thumbnailImageUrl = preview.images[0].resolutions!.isNotEmpty
            ? preview.images.first.resolutions![1].url
            : originalImageUrl;

        return [
          Wallpaper(
            subreddit: subreddit,
            author: author,
            upvotes: upvotes,
            postUrl: postUrl,
            rating: rating,
            images: Images(
              thumbnailImageUrl: thumbnailImageUrl,
              originalImageUrl: originalImageUrl,
              width: width,
              height: height,
            ),
            createdAt: created,
          ),
        ];
      }
    }

    // If the entity has multiple wallpaper
    if (data.galleryData != null) {
      final wallpapers = <Wallpaper>[];
      final galleryData = data.galleryData!;
      final metadata = data.mediaMetadata!;

      for (final item in galleryData.items) {
        final mediaId = item.mediaId;
        final media = metadata[mediaId]!;

        if (media.p != null && media.s != null) {
          final mIndex = media.p!.length.thumbnailIndex;

          //Images
          final originalImageUrl = media.s!.u;
          final width = media.s!.x;
          final height = media.s!.y;
          final thumbnailImageUrl =
              media.p!.isNotEmpty ? media.p![mIndex].u : originalImageUrl;

          final wallpaper = Wallpaper(
            subreddit: subreddit,
            author: author,
            upvotes: upvotes,
            postUrl: postUrl,
            rating: rating,
            images: Images(
              thumbnailImageUrl: thumbnailImageUrl,
              originalImageUrl: originalImageUrl,
              width: width,
              height: height,
            ),
            createdAt: created,
          );

          wallpapers.add(wallpaper);
        }
      }

      return wallpapers;
    }

    return [];
  }

  List<Wallpaper> toWallpapers(
    List<WallpaperEntity> entities,
    Subreddit subreddit,
  ) {
    final wallpapers = <Wallpaper>[];
    for (final entity in entities) {
      final walls = wallpaperEntityToWallpaper(entity, subreddit);
      wallpapers.addAll(walls);
    }
    return wallpapers;
  }

  Subreddit subredditEntitytoSubreddit(SubredditEntity entity) {
    final data = entity.data;

    final subredditName = data.displayNamePrefixed;
    final subscribersCount = data.subscribers;
    final description = data.publicDescription;
    final iconImageUrl = data.iconImg == '' ? null : data.iconImg;
    final bannerImageUrl =
        data.bannerBackgroundImage == '' ? null : data.bannerBackgroundImage;
    final primaryColor = data.primaryColor;

    return Subreddit(
      subredditName: subredditName,
      subscribersCount: subscribersCount,
      description: description,
      iconImageUrl: iconImageUrl,
      bannerImageUrl: bannerImageUrl,
      primaryColor: primaryColor,
    );
  }

  List<Subreddit> toSubreddits(List<SubredditEntity> entities) {
    return entities.map<Subreddit>(subredditEntitytoSubreddit).toList();
  }
}
