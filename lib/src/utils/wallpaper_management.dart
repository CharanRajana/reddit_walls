import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart'
    show WallpaperManagerPlus;

class WallpaperManagementUtility {
  static Future<String> downloadWallpaper(
    String subredditName,
    String imageUrl,
  ) async {
    // Fetch the image
    final response = await http.get(Uri.parse(imageUrl));

    const dirPath = '/storage/emulated/0/Pictures/Reddit Walls';
    await Directory(dirPath).create(recursive: true);

    final fileName = generateFilename(subredditName, imageUrl);
    // Save the image
    final file = File(
      path.join(dirPath, '$fileName.jpg'),
    );
    await file.writeAsBytes(response.bodyBytes);

    return file.path;
  }

  static Future<String?> setWallpaper(String imageUrl, int location) async {
    final wallpaperManagerPlus = WallpaperManagerPlus();
    final file = await DefaultCacheManager().getSingleFile(imageUrl);
    return wallpaperManagerPlus.setWallpaper(
      file,
      location,
    );
  }
}

String generateFilename(String subredditName, String imageUrl) {
  final subreddit = subredditName.replaceAll(RegExp('[^a-zA-Z0-9]'), '_');

  final imageIdentifier = Uri.parse(imageUrl).queryParameters['s'];

  return '${subreddit}_$imageIdentifier';
}
