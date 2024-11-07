import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reddit_walls/src/features/home/collections_page.dart';
import 'package:reddit_walls/src/features/home/cubit/collection_cubit.dart';
import 'package:reddit_walls/src/features/settings/settings_page.dart';
import 'package:reddit_walls/src/features/wallpaper/favourites_page.dart';
import 'package:reddit_walls/src/utils/extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppTitleWidget(),
        centerTitle: true,
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final state =
                  ref.watch(collectionNotifierProvider).collections.isNotEmpty;
              return state
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: const Icon(Icons.delete_rounded),
                        onPressed: () => context
                            .read<CollectionNotifier>()
                            .removeSelectedCollection(),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          CollectionsPage(),
          FavoritesPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.collections_bookmark_rounded),
            icon: Icon(Icons.collections_bookmark_outlined),
            label: 'Collections',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite_rounded),
            icon: Icon(Icons.favorite_outline_rounded),
            label: 'Favorites',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings_rounded),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}

class AppTitleWidget extends StatelessWidget {
  const AppTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Reddit',
        children: [
          TextSpan(
            text: 'Walls',
            style: GoogleFonts.rubikMonoOne(
              textStyle: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.7,
                color: context.colorScheme.primary,
              ),
            ),
          ),
        ],
        style: GoogleFonts.rubikMonoOne(
          textStyle: context.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.7,
            color: context.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
