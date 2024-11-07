import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WallpaperGridCardPlaceholder extends StatelessWidget {
  const WallpaperGridCardPlaceholder({
    required this.height,
    super.key,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Card(
        child: SizedBox.expand(),
      ),
    );
  }
}

class WallpaperGridPlaceHolderLayout extends StatelessWidget {
  const WallpaperGridPlaceHolderLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childCount: 20,
      itemBuilder: (context, index) => WallpaperGridCardPlaceholder(
        height: index.isEven ? 400 : 200,
      ),
    );
  }
}
