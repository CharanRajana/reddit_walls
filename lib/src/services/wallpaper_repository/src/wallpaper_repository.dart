import 'package:reddit_walls/src/services/reddit_wallpaper_client/lib/reddit_wallpaper_client.dart';
import 'package:reddit_walls/src/services/wallpaper_repository/src/models/models.dart';
import 'package:reddit_walls/src/services/wallpaper_repository/src/utils/data_mapper.dart';

class WallpaperRepository {
  WallpaperRepository({RedditWallpaperClient? redditWallpaperClient})
      : _redditWallpaperClient =
            redditWallpaperClient ?? RedditWallpaperClient();

  final RedditWallpaperClient _redditWallpaperClient;
  final DataMapper _dataMapper = DataMapper();

  Future<WallpaperResponse> getWallpapers({
    required Subreddit subreddit,
    Sort sort = Sort.today,
    String after = '',
    int limit = 15,
  }) async {
    final wallpapersLising = await _redditWallpaperClient.getWallpapers(
      subreddit: subreddit.subredditName,
      sort: sort,
      after: after,
      limit: limit,
    );

    return WallpaperResponse(
      after: after,
      wallpapers:
          _dataMapper.toWallpapers(wallpapersLising.children, subreddit),
    );
  }

  Future<SubredditResponse> searchSubreddits({
    required String query,
    String after = '',
    int limit = 15,
  }) async {
    final subredditListing = await _redditWallpaperClient.searchSubreddits(
      query: query,
      after: after,
      limit: limit,
    );

    return SubredditResponse(
      after: after,
      subreddits: _dataMapper.toSubreddits(subredditListing.children),
    );
  }
}
