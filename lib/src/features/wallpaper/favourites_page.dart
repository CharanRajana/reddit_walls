import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:reddit_walls/src/features/wallpaper/widgets/wallpaper_grid_card.dart';
import 'package:reddit_walls/src/services/data.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: favouriteWallpapersData,
        builder: (context, value, child) {
          final favourites = value.toList();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomScrollView(
              slivers: [
                if (favourites.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('No Favourites yet!'),
                    ),
                  )
                else
                  SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childCount: favourites.length,
                    itemBuilder: (context, index) => WallpaperGridCard(
                      wallpaper: favourites[index],
                      height: index.isEven ? 400 : 200,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
