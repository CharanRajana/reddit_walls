import 'package:equatable/equatable.dart';
import 'package:reddit_walls/src/services/wallpaper_repository/src/models/subreddit.dart';

class WallpaperResponse extends Equatable {
  const WallpaperResponse({required this.after, required this.wallpapers});

  final String? after;
  final List<Wallpaper> wallpapers;

  @override
  List<Object?> get props => [after, wallpapers];

  WallpaperResponse copyWith({String? after, List<Wallpaper>? wallpapers}) {
    return WallpaperResponse(
      after: after ?? this.after,
      wallpapers: wallpapers ?? this.wallpapers,
    );
  }
}

class Wallpaper extends Equatable {
  const Wallpaper({
    required this.subreddit,
    required this.author,
    required this.upvotes,
    required this.postUrl,
    required this.rating,
    required this.images,
    required this.createdAt,
  });

  final Subreddit subreddit;
  final String author;
  final String postUrl;
  final int upvotes;
  final double rating;
  final Images images;
  final DateTime createdAt;

  @override
  List<Object?> get props =>
      [subreddit, images, rating, author, createdAt, postUrl];
}

class Images extends Equatable {
  const Images({
    required this.thumbnailImageUrl,
    required this.originalImageUrl,
    required this.width,
    required this.height,
  });

  final String thumbnailImageUrl;
  final String originalImageUrl;
  final int width;
  final int height;

  @override
  List<Object?> get props =>
      [thumbnailImageUrl, originalImageUrl, width, height];
}
