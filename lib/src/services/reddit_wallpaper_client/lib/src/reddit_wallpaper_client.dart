import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reddit_walls/src/services/reddit_wallpaper_client/lib/src/exceptions.dart';
import 'package:reddit_walls/src/services/reddit_wallpaper_client/lib/src/models/models.dart';

enum Sort { today, week, month, year, all }

class RedditWallpaperClient {
  static const String baseUrl = 'old.reddit.com';

  Future<WallpaperListing> getWallpapers({
    required String subreddit,
    Sort sort = Sort.today,
    String after = '',
    int limit = 15,
  }) async {
    final filter = sort == Sort.today ? 'hot' : 'top';

    final url = Uri.https(
      baseUrl,
      '/$subreddit/$filter/.json',
      {
        't': sort.name,
        'limit': limit.toString(),
        'after': after,
        'raw_json': '1',
      },
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw WallpaperRequestFailure();
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    return WallpaperListing.fromJson(
      responseData['data'] as Map<String, dynamic>,
    );
  }

  Future<SubredditListing> searchSubreddits({
    required String query,
    String after = '',
    int limit = 15,
  }) async {
    final url = Uri.https(baseUrl, '/subreddits/search/.json', {
      'q': query,
      'limit': limit.toString(),
      'after': after,
      'raw_json': '1',
    });

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw SubredditRequestFailure();
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;

    return SubredditListing.fromJson(
      responseData['data'] as Map<String, dynamic>,
    );
  }
}
