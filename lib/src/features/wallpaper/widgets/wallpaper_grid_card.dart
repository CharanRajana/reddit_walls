import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reddit_walls/src/features/wallpaper/details_page.dart';
import 'package:reddit_walls/src/services/wallpaper_repository/wallpaper_repository.dart';

class WallpaperGridCard extends StatelessWidget {
  const WallpaperGridCard({
    required this.wallpaper,
    required this.height,
    super.key,
  });

  final Wallpaper wallpaper;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailsPage(
            wallpaper: wallpaper,
          ),
        ),
      ),
      child: SizedBox(
        height: height,
        child: Card(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Hero(
              tag: wallpaper.images.originalImageUrl,
              // child: FadeInImage.memoryNetwork(
              //   placeholder: kTransparentImage,
              //   image: wallpaper.images.thumbnailImageUrl,
              //   fit: BoxFit.cover,
              // ),
              child: CachedNetworkImage(
                imageUrl: wallpaper.images.thumbnailImageUrl,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
