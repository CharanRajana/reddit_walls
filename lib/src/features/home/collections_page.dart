import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_walls/src/features/home/cubit/collection_cubit.dart';
import 'package:reddit_walls/src/features/search/search_page.dart';
import 'package:reddit_walls/src/features/wallpaper/feed_page.dart';
import 'package:reddit_walls/src/services/wallpaper_repository/wallpaper_repository.dart';
import 'package:reddit_walls/src/utils/assets.dart';
import 'package:reddit_walls/src/utils/extensions.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CustomFloatingActionButton(),
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(collectionNotifierProvider);
          final collections = state.collections.toList();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: collections.isEmpty
                ? const Center(
                    child: Text('No subreddits added yet!'),
                  )
                : ListView.separated(
                    itemCount: collections.length,
                    itemBuilder: (context, index) {
                      final subreddit = collections[index];
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                FeedPage(subreddit: subreddit),
                          ),
                        ),
                        child: SubredditCard(
                          subreddit: subreddit,
                          selectedSubreddits: state.selectedCollections,
                          isSelected: ref
                              .read(collectionNotifierProvider.notifier)
                              .isInSelected(subreddit),
                          onChanged: (value) => ref
                              .read(collectionNotifierProvider.notifier)
                              .performMultiSelect(subreddit),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                  ),
          );
        },
      ),
    );
  }
}

class SubredditCard extends StatelessWidget {
  const SubredditCard({
    required this.subreddit,
    required this.selectedSubreddits,
    required this.isSelected,
    super.key,
    this.onChanged,
  });

  final Subreddit subreddit;
  final Set<Subreddit> selectedSubreddits;
  final bool isSelected;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: subreddit.bannerImageUrl.isNull
                  ? Image.asset(
                      AssetsUtility.subredditBgImage,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: subreddit.bannerImageUrl!,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.6),
              ),
              child: Center(
                child: Text(
                  subreddit.subredditName,
                  style: context.textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Checkbox(
                side: const BorderSide(color: Colors.white70, width: 2),
                value: isSelected,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: FittedBox(
        child: FloatingActionButton.extended(
          heroTag: '_subredditSearchToggle',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SearchPage(),
            ),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Add'),
          clipBehavior: Clip.antiAlias,
          elevation: 2,
        ),
      ),
    );
  }
}
