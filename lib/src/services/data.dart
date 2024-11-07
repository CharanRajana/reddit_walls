import 'package:flutter/material.dart';
import 'package:reddit_walls/src/services/wallpaper_repository/wallpaper_repository.dart';

final ValueNotifier<Set<Subreddit>> subredditsData =
    ValueNotifier<Set<Subreddit>>({});

final ValueNotifier<Set<Wallpaper>> favouriteWallpapersData =
    ValueNotifier<Set<Wallpaper>>({});

class SubredditsDataHandler {
  static void add(Subreddit subreddit) {
    subredditsData.value = Set.from(subredditsData.value)..add(subreddit);
  }

  static void remove(Subreddit subreddit) {
    subredditsData.value = Set.from(subredditsData.value)
      ..removeWhere((sub) => sub == subreddit);
  }

  static void removeAll(Set<Subreddit> subs) {
    subredditsData.value = Set.from(subredditsData.value)
      ..removeWhere((sub) => subs.contains(sub));
  }

  static bool isExists(Subreddit subreddit) {
    return subredditsData.value.contains(subreddit);
  }
}

class WallpaperDataHandler {
  static void add(Wallpaper wallpaper) {
    favouriteWallpapersData.value = Set.from(favouriteWallpapersData.value)
      ..add(wallpaper);
  }

  static void remove(Wallpaper wallpaper) {
    favouriteWallpapersData.value = Set.from(favouriteWallpapersData.value)
      ..removeWhere((wall) => wall == wallpaper);
  }

  static bool isFavourite(Wallpaper wallpaper) {
    return favouriteWallpapersData.value.contains(wallpaper);
  }
}
